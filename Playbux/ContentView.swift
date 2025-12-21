//
//  ContentView.swift
//  Playbux
//
//  Created by Daniel Jilg on 21.12.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var sessions: [Session]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(sessions) { session in
                    NavigationLink {
                        Text("Session: \(session.name)")
                    } label: {
                        Text(session.name)
                    }
                }
                .onDelete(perform: deleteSessions)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addSession) {
                        Label("Add Session", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a session")
        }
    }

    private func addSession() {
        withAnimation {
            let newSession = Session(name: "New Game")
            modelContext.insert(newSession)
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
