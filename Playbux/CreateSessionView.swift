//
//  CreateSessionView.swift
//  Playbux
//
//  Created by Daniel Jilg on 03.01.26.
//

import SwiftData
import SwiftUI

struct CreateSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var session: Session
    @Query(filter: #Predicate<Session> { $0.isStarted }) private var existingSessions: [Session]

    private var isSubmitDisabled: Bool {
        session.name.trimmingCharacters(in: .whitespaces).isEmpty || session.resourceTypes.isEmpty
    }

    var body: some View {
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

            // Start Game Section
            Section {
                BigSubmitButton(title: "start_game", isDisabled: isSubmitDisabled) {
                    session.startSession()
                }
            }
        }
        .navigationTitle(Text("create_session"))
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
}
