//
//  SessionView.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftData
import SwiftUI

struct SessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var session: Session
    @State private var showBankPayoutSheet = false
    @State private var showAddPlayerSheet = false

    var body: some View {
        List {
            Section {
                ForEach(session.players) { player in
                    NavigationLink {
                        PlayerBalanceView(player: player)
                    } label: {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(player.color)
                                .frame(width: 6)
                            Text(player.displayName)
                        }
                    }
                }
                .onDelete(perform: deletePlayers)
            }
            header: { Text("players") }

            Section {
                Button("bank_payout") {
                    showBankPayoutSheet = true
                }
            }
            header: { Text("bank") }
        }
        .navigationTitle(session.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddPlayerSheet = true
                } label: {
                    Label(String(localized: "add_player"), systemImage: "person.badge.plus")
                }
            }
        }
        .sheet(isPresented: $showBankPayoutSheet) {
            NewTransactionView(session: session)
        }
        .sheet(isPresented: $showAddPlayerSheet) {
            CreatePlayerView(session: session)
        }
    }

    private func deletePlayers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(session.players[index])
            }
        }
    }
}
