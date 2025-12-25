//
//  SessionView.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct SessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var session: Session

    var body: some View {
        List {
            Section {
                ForEach(session.players) { player in
                    NavigationLink {
                        PlayerBalanceView(player: player)
                    } label: {
                        Text(player.name)
                    }
                }
            }
            header: { Text("Spieler*innen") }

            Section {
                NavigationLink("Einstellungen", destination: SessionSettings(session: session))
            }
        }
        .navigationTitle(session.name)
    }
}
