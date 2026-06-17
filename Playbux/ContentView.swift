//
//  ContentView.swift
//  Playbux
//
//  Created by Daniel Jilg on 21.12.25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var sessions: [Session]

    @State private var navigationPath = NavigationPath()

    // A single adaptive item packs as many columns as fit the available width.
    // `spacing` here sets the gap between columns; the LazyVGrid's own `spacing` sets the gap between rows.
    private let columns = [GridItem(.adaptive(minimum: 160, maximum: 500), spacing: 16)]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(sessions) { session in
                        NavigationLink(value: session) {
                            SessionPackageCell(session: session)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(role: .destructive) {
                                delete(session)
                            } label: {
                                Label(String(localized: "delete"), systemImage: "trash")
                            }
                        }
                    }
                }
                .padding()
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .navigationDestination(for: Session.self) { session in
                if session.isStarted {
                    SessionView(session: session)
                } else {
                    CreateSessionView(session: session)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addSession) {
                        Label(String(localized: "add_session"), systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addSession() {
        withAnimation {
            let newSession = Session(name: String(localized: "new_game"))
            modelContext.insert(newSession)
            navigationPath.append(newSession)
        }
    }

    private func delete(_ session: Session) {
        withAnimation {
            modelContext.delete(session)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Session.self, inMemory: true)
}
