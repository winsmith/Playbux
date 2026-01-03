//
//  CreatePlayerView.swift
//  Playbux
//
//  Created by Daniel Jilg on 03.01.26.
//

import SwiftUI

struct CreatePlayerView: View {
    @Environment(\.dismiss) private var dismiss
    var session: Session

    @State private var playerName: String = ""
    @State private var playerEmoji: String = Player.emojiPool.randomElement()!

    private var isSubmitDisabled: Bool {
        playerName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        TextField("emoji", text: $playerEmoji)
                            .frame(width: 50)
                        TextField("player_name", text: $playerName)
                            .textContentType(.name)
                    }
                }
                header: { Text("player_name") }

                Section {
                    BigSubmitButton(title: "add_player", isDisabled: isSubmitDisabled) {
                        addPlayer()
                        dismiss()
                    }
                }
            }
            .navigationTitle(Text("add_player"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func addPlayer() {
        let newPlayer = Player(name: playerName, emoji: playerEmoji)
        session.addPlayer(newPlayer)
    }
}
