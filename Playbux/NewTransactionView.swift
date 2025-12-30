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

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if let fromPlayer {
                        Text(fromPlayer.name)
                    } else {
                        Text("bank")
                    }
                }
                header: { Text("from") }

                Section {
                    Picker(String(localized: "recipient"), selection: $toPlayer) {
                        if fromPlayer != nil {
                            Text("bank").tag(nil as Player?)
                            Divider()
                        }
                        ForEach(players, id: \.self) { player in
                            Text(player.name).tag(player as Player?)
                        }
                    }
                }
                header: { Text("to") }

                Section {
                    Picker(String(localized: "currency"), selection: $resourceType) {
                        ForEach(resourceTypes, id: \.self) { resourceType in
                            Text(resourceType.name).tag(resourceType)
                        }
                    }
                }
                header: { Text("resource") }

                Section {
                    TextField("amount", value: $amount, format: .number)
                    #if os(iOS)
                        .keyboardType(.numberPad)
                    #endif
                }
                header: { Text("amount") }

                Section {
                    TextField("note", text: $note)
                }
                header: { Text("optional_note") }

                Button("submit") {
                    let savedNote: String? = note.isEmpty ? nil : note

                    // save transaction
                    session.createNewTransaction(
                        from: fromPlayer,
                        to: toPlayer,
                        resourceType: resourceType,
                        amount: amount,
                        note: savedNote
                    )

                    // dismiss sheet
                    dismiss()
                }
                .disabled(amount <= 0 || (fromPlayer == nil && toPlayer == nil))
            }
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
