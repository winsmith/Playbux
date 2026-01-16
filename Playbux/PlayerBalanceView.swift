//
//  PlayerBalanceView.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    let player: Player

    private var isOutgoing: Bool {
        transaction.fromPlayer == player
    }

    private var otherPartyName: String {
        if isOutgoing {
            return transaction.toPlayer?.name ?? String(localized: "bank")
        } else {
            return transaction.fromPlayer?.name ?? String(localized: "bank")
        }
    }

    private var displayAmount: String {
        if isOutgoing {
            return "-\(transaction.amount)"
        } else {
            return "+\(transaction.amount)"
        }
    }

    private var amountColor: Color {
        isOutgoing ? .red : .green
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(otherPartyName)
                    .font(.body)

                Spacer()

                HStack(spacing: 4) {
                    Text(displayAmount)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text(transaction.resourceType?.emoji ?? "")
                        .font(.system(size: 18))
                }
                .foregroundStyle(amountColor)
            }
            .padding(.vertical, 4)

            if let note = transaction.note {
                Text(note)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct PlayerBalanceView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var player: Player
    @State private var showNewTransactionSheet = false

    private var playerTransactions: [Transaction] {
        (player.session?.transactions ?? []).filter { transaction in
            transaction.fromPlayer == player || transaction.toPlayer == player
        }
    }

    var body: some View {
        List {
            Section {
                ForEach(player.balances) { balance in
                    VStack(alignment: .trailing) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Spacer()

                            Text("\(balance.amount)")
                                .font(.system(size: 48, weight: .bold, design: .rounded))

                            Text(balance.resourceType?.emoji ?? "")
                                .font(.system(size: 36))
                        }

                        Text(balance.resourceType?.name ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            header: { Text("balances") }

            Section {
                ForEach(playerTransactions) { transaction in
                    TransactionRow(transaction: transaction, player: player)
                }
            }
            header: { Text("transactions") }
        }
        .navigationTitle(player.displayName)
        .safeAreaInset(edge: .top, spacing: 0) {
            player.color
                .frame(height: 8)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showNewTransactionSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showNewTransactionSheet) {
            NewTransactionView(fromPlayer: player)
        }
    }
}
