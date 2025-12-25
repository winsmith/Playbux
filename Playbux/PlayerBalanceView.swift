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

    @State var showNewTransactionView = false

    var body: some View {
        List {
            Section {
                ForEach(player.balances) { balance in
                    Text("\(balance.amount) \(balance.resourceType?.displayName ?? "")")
                }
            }
            header: { Text("Kontostände") }

            Section {
                NavigationLink("Überweisung", destination: NewTransactionView(showView: $showNewTransactionView, fromPlayer: player), isActive: $showNewTransactionView)
            }
            header: { Text("Neu") }

            Section {
                ForEach(player.session?.transactions ?? []) { transaction in
                    Text(transaction.summary)
                }
            }
            header: { Text("Transaktionen") }
        }
        .navigationTitle(player.name)
    }
}
