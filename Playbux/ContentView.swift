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

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(sessions) { session in
                    NavigationLink(value: session) {
                        HStack {
                            Text(session.name)
                            Spacer()
                            if !session.isStarted {
                                Text("draft")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteSessions)
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
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
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

    private func deleteSessions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(sessions[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Session.self, inMemory: true)
}
