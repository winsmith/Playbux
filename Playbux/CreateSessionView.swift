//
//  CreateSessionView.swift
//  Playbux
//
//  Created by Daniel Jilg on 03.01.26.
//

import ImageIO
import ImagePlayground
import SwiftData
import SwiftUI

struct CreateSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var session: Session
    @Query(filter: #Predicate<Session> { $0.isStarted }) private var existingSessions: [Session]

    @State private var boxImage: CGImage?
    @State private var isPresentingPlayground = false

    private var isSubmitDisabled: Bool {
        session.name.trimmingCharacters(in: .whitespaces).isEmpty || session.resourceTypes.isEmpty
    }

    /// Image Playground composes short, concrete *concepts* — it isn't a freeform prompt, and the
    /// on-device model is tiny (and can't render text). Concrete nouns work far better than an
    /// abstract title, so we lead with a "tabletop game" anchor (clearer than "board game", which
    /// the model confuses with surfboards/whiteboards), add the session's first few resource names
    /// (wood, sheep, …) since those are concrete and visual, and let the system distill any
    /// remaining theme from the session's name. Style is set via `imagePlaygroundGenerationStyle`.
    private var imageConcepts: [ImagePlaygroundConcept] {
        var concepts: [ImagePlaygroundConcept] = [.text("tabletop game")]
        concepts += session.resourceTypes.prefix(3).map { .text($0.name) }
        concepts.append(.extracted(from: session.name))
        return concepts
    }

    var body: some View {
        NavigationStack {
            Form {
                // Session Name Section
                Section {
                    TextField("session_name", text: $session.name)
                        .textContentType(.name)
                }
                header: { Text("session_name") }
                footer: { Text("session_name_explainer") }

                // Resource Types Section
                Section {
                    ForEach(session.resourceTypes) { resourceType in
                        NavigationLink {
                            SessionResourceTypeSettings(resourceType: resourceType)
                        } label: {
                            HStack {
                                Text(resourceType.emoji)
                                Text(resourceType.name)
                                Spacer()
                                Text("\(resourceType.initialPlayerAmount)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteResourceType)

                    Button(action: addResourceType) {
                        Label(String(localized: "add_resource_type"), systemImage: "plus")
                    }

                    if !existingSessions.isEmpty {
                        Menu {
                            ForEach(existingSessions) { existingSession in
                                Button(existingSession.name) {
                                    copyResourceTypes(from: existingSession)
                                }
                            }
                        } label: {
                            Label(String(localized: "copy_from_game"), systemImage: "doc.on.doc")
                        }
                    }
                }
                header: { Text("resources") }
                footer: { Text("resources_explainer") }

                // Box Image Section — the generated art is seeded from the name and resources,
                // so it lives below them and stays disabled until at least one resource exists.
                Section {
                    if let boxImage {
                        Image(boxImage, scale: 1.0, label: Text(session.name))
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .listRowInsets(EdgeInsets())
                    }

                    Button {
                        isPresentingPlayground = true
                    } label: {
                        Label(String(localized: "create_image"), systemImage: "sparkles")
                    }
                    .disabled(session.resourceTypes.isEmpty)
                }
                header: { Text("box_image") }
                footer: { Text("box_image_explainer") }

                // Start Game Section
                Section {
                    BigSubmitButton(title: "start_game", isDisabled: isSubmitDisabled) {
                        session.startSession()
                        dismiss()
                    }
                }
            }
            .navigationTitle(Text("create_session"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        dismiss()
                    }
                }
            }
            .task(id: session.persistentModelID) {
                boxImage = BoxImageCache.image(for: session)
            }
            .imagePlaygroundSheet(isPresented: $isPresentingPlayground, concepts: imageConcepts) { url in
                guard let image = loadCGImage(from: url) else { return }
                boxImage = image
                Task { await BoxImageCache.store(image, for: session) }
            }
            .imagePlaygroundGenerationStyle(.illustration)
        }
    }

    private func addResourceType() {
        withAnimation {
            let newResourceType = session.nextExampleResourceType()
            session.resourceTypes.append(newResourceType)
        }
    }

    private func deleteResourceType(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(session.resourceTypes[index])
            }
        }
    }

    private func copyResourceTypes(from sourceSession: Session) {
        withAnimation {
            // Clear existing resource types
            for resourceType in session.resourceTypes {
                modelContext.delete(resourceType)
            }

            // Copy resource types from source session
            for sourceType in sourceSession.resourceTypes {
                let newType = ResourceType(
                    name: sourceType.name,
                    emoji: sourceType.emoji,
                    initialBankAmount: sourceType.initialBankAmount,
                    initialPlayerAmount: sourceType.initialPlayerAmount,
                    displayOrder: sourceType.displayOrder
                )
                session.resourceTypes.append(newType)
            }
        }
    }

    private func loadCGImage(from url: URL) -> CGImage? {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }
}
