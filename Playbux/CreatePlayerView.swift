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
    @State private var playerColor: Color = Color(hex: Player.colorPool.randomElement()!)!

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
                            .onChange(of: playerEmoji) { _, newValue in
                                // Accept exactly one emoji: drop letters/digits/punctuation and
                                // keep only the most recently entered emoji character.
                                let sanitized = Self.sanitizedEmoji(from: newValue)
                                if sanitized != newValue {
                                    playerEmoji = sanitized
                                }
                            }
                        TextField("player_name", text: $playerName)
                            .textContentType(.name)
                    }
                    ColorPicker("color", selection: $playerColor, supportsOpacity: false)
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
        let colorHex = playerColor.toHex() ?? "#007AFF"
        // Fall back to a random emoji if the field was cleared.
        let emoji = playerEmoji.isEmpty ? nil : playerEmoji
        let newPlayer = Player(name: playerName, emoji: emoji, displayOrder: 0, colorHex: colorHex)
        session.addPlayer(newPlayer)
    }

    /// The most recently entered emoji in `input`, or "" if it has none. Rejects letters, digits,
    /// and punctuation, and collapses multiple emoji down to a single one.
    private static func sanitizedEmoji(from input: String) -> String {
        guard let lastEmoji = input.reversed().first(where: { $0.isEmoji }) else { return "" }
        return String(lastEmoji)
    }
}

private extension Character {
    /// True for emoji — including multi-scalar sequences (flags, skin tones, ZWJ families,
    /// keycaps) — but not plain digits or symbols that merely have an emoji presentation form.
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        if unicodeScalars.count > 1 {
            return scalar.properties.isEmoji
        }
        return scalar.properties.isEmojiPresentation
    }
}
