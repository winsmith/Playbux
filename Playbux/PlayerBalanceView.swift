//
//  PlayerBalanceView.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct PlayerBalanceView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var player: Player
    @State private var showNewTransactionSheet = false

    var body: some View {
        List {
            Section {
                ForEach(player.balances) { balance in
                    Text("\(balance.amount) \(balance.resourceType?.displayName ?? "")")
                }
            }
            header: { Text("balances") }

            Section {
                Button(String(localized: "transaction")) {
                    showNewTransactionSheet = true
                }
            }
            header: { Text("new") }

            Section {
                ForEach(player.session?.transactions ?? []) { transaction in
                    Text(transaction.summary)
                }
            }
            header: { Text("transactions") }
        }
        .navigationTitle(player.name)
        .sheet(isPresented: $showNewTransactionSheet) {
            NewTransactionView(fromPlayer: player)
        }
    }
}
