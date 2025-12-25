//
//  SessionPlayerSettings.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftData
import SwiftUI

struct SessionPlayersSettings: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var session: Session

    var body: some View {
        List {
            ForEach(session.players) { player in
                NavigationLink {
                    SessionPlayerSettings(player: player)
                } label: {
                    Text(player.name)
                }
            }
            .onDelete(perform: deletePlayer)
        }
        .navigationTitle("Players")
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
#endif
            ToolbarItem {
                Button(action: addPlayer) {
                    Label("Add Player", systemImage: "plus")
                }
            }
        }
    }

    private func addPlayer() {
        withAnimation {
            let newPlayer = Player(name: "New Player")
            session.players.append(newPlayer)
        }
    }

    private func deletePlayer(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(session.players[index])
            }
        }
    }
}
