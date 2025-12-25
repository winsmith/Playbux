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
    @State private var isShowingDialog = false

    var body: some View {
        List {
            if session.isStarted {
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
            }
            else {
                Section {
                    NavigationLink("Einstellungen", destination: SessionSettings(session: session))
                }
                Button("Spiel starten") {
                    isShowingDialog = true
                }
                .confirmationDialog(
                    "Spiel wirklich starten? Danach können die Einstellungen nicht mehr geändert werden.",
                    isPresented: $isShowingDialog
                ) {
                    Button("Spiel wirklich starten", role: .destructive) {
                        session.startSession()
                    }
                    Button("Abbrechen", role: .cancel) {
                        isShowingDialog = false
                    }
                }
            }
        }
        .navigationTitle(session.name)
    }
}
