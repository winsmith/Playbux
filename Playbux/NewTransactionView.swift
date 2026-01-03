//
//  NewTransactionView.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct NewTransactionView: View {
    @Environment(\.dismiss) private var dismiss

    var fromPlayer: Player?
    var session: Session

    @State var toPlayer: Player?
    @State var resourceType: ResourceType
    @State var amount: Int = 0
    @State var note: String = ""

    private var resourceTypes: [ResourceType] {
        session.resourceTypes
    }

    private var players: [Player] {
        session.players
    }

    /// Initialize for a player-to-player or player-to-bank transaction
    init(fromPlayer: Player) {
        self.fromPlayer = fromPlayer
        guard let session = fromPlayer.session else {
            fatalError("Cannot create transaction: player has no session")
        }
        self.session = session
        guard let firstResourceType = session.resourceTypes.first else {
            fatalError("Cannot create transaction: no resource types configured for this session")
        }
        self._resourceType = State(initialValue: firstResourceType)
    }

    /// Initialize for a bank-to-player transaction
    init(session: Session) {
        self.fromPlayer = nil
        self.session = session
        guard let firstResourceType = session.resourceTypes.first else {
            fatalError("Cannot create transaction: no resource types configured for this session")
        }
        self._resourceType = State(initialValue: firstResourceType)
        // Default to first player since bank-to-bank is not allowed
        self._toPlayer = State(initialValue: session.players.first)
    }

    private var fromName: String {
        fromPlayer?.name ?? String(localized: "bank")
    }

    private var isSubmitDisabled: Bool {
        amount <= 0 || (fromPlayer == nil && toPlayer == nil)
    }

    /// Options for the recipient picker - includes Bank option only when fromPlayer is set, excludes fromPlayer
    private var recipientOptions: [Player?] {
        let availablePlayers = players.filter { $0 != fromPlayer }
        if fromPlayer != nil {
            return [nil] + availablePlayers
        } else {
            return availablePlayers.map { $0 as Player? }
        }
    }

    private func recipientName(_ player: Player?) -> String {
        player?.name ?? String(localized: "bank")
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // From -> To row
                HStack(spacing: 16) {
                    // From
                    VStack(spacing: 4) {
                        Text(fromName)
                            .font(.headline)
                            .lineLimit(1)
                        Text("from")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    // Arrow
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    // To (picker styled as inline menu)
                    VStack(spacing: 4) {
                        Picker(selection: $toPlayer) {
                            ForEach(recipientOptions, id: \.self) { player in
                                Text(recipientName(player)).tag(player)
                            }
                        } label: {
                            EmptyView()
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()

                        Text("to")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))

                // Amount input
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        TextField("0", value: $amount, format: .number)
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.trailing)
                            .minimumScaleFactor(0.5)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            #endif

                        Text(resourceType.emoji)
                            .font(.system(size: 48))
                    }

                    if resourceTypes.count > 1 {
                        Picker(selection: $resourceType) {
                            ForEach(resourceTypes, id: \.self) { type in
                                Text(type.name).tag(type)
                            }
                        } label: {
                            EmptyView()
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    } else {
                        Text(resourceType.name)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))

                // Optional note
                TextField("note", text: $note)
                    .textFieldStyle(.roundedBorder)

                Spacer()

                // Submit button
                BigSubmitButton(title: "submit", isDisabled: isSubmitDisabled) {
                    let savedNote: String? = note.isEmpty ? nil : note

                    session.createNewTransaction(
                        from: fromPlayer,
                        to: toPlayer,
                        resourceType: resourceType,
                        amount: amount,
                        note: savedNote
                    )

                    dismiss()
                }
            }
            .padding()
            .navigationTitle(Text("new_transaction"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
