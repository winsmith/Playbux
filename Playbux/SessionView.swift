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
    @State private var showBankPayoutSheet = false

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
                header: { Text("players") }

                Section {
                    Button("bank_payout") {
                        showBankPayoutSheet = true
                    }
                }
                header: { Text("bank") }
            }
            else {
                Section {
                    NavigationLink(String(localized: "settings"), destination: SessionSettings(session: session))
                }
                Button("start_game") {
                    isShowingDialog = true
                }
                .confirmationDialog(
                    Text("confirm_start_game"),
                    isPresented: $isShowingDialog
                ) {
                    Button("confirm_start_game_button", role: .destructive) {
                        session.startSession()
                    }
                    Button("cancel", role: .cancel) {
                        isShowingDialog = false
                    }
                }
            }
        }
        .navigationTitle(session.name)
        .sheet(isPresented: $showBankPayoutSheet) {
            NewTransactionView(session: session)
        }
    }
}
