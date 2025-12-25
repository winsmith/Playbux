//
//  NewTransactionView.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct NewTransactionView: View {
    @Binding var showView: Bool

    @Bindable var fromPlayer: Player

    @State var toPlayer: Player?
    @State var resourceType: ResourceType?
    @State var amount: Int = 0
    @State var note: String = ""

    var body: some View {
        Form {
            Section {
                Text(fromPlayer.name)
            }
            header: { Text("Von") }

            Section {
                Picker("Empfänger", selection: $toPlayer) {
                    Text("Bank").tag(nil as Player?)
                    Divider()
                    ForEach(fromPlayer.session?.players ?? [], id: \.self) { player in
                        // FIXME: Picker: the selection "Optional(Playbux.Player)" is invalid and does not have an associated tag, this will give undefined results.
                        Text(player.name).tag(player)
                    }
                }
            }
            header: { Text("An") }

            Section {
                Picker("Währung", selection: $resourceType) {
                    Text("Bitte Währung wählen").tag(nil as ResourceType?)
                    Divider()
                    ForEach(fromPlayer.session?.resourceTypes ?? [], id: \.self) { resourceType in
                        Text(resourceType.name).tag(resourceType)
                    }
                }
            }
            header: { Text("Resource") }

            Section {
                TextField("Betrag", value: $amount, format: .number)
                    .keyboardType(.numberPad)
            }
            header: { Text("Betrag") }

            Section {
                TextField("Notiz", text: $note)
            }
            header: { Text("Optionale Notiz") }

            Button("Abschicken") {
                print("Abschicken")
                guard let resourceType else { return }

                var savedNote: String? = nil
                if note.isEmpty {
                } else {
                    savedNote = note
                }

                // überweisung speichern
                fromPlayer.session?.createNewTransaction(
                    from: fromPlayer,
                    to: toPlayer,
                    resourceType: resourceType,
                    amount: amount,
                    note: savedNote
                )

                // navigation zurück
                showView = false
            }
            .disabled(resourceType == nil && amount <= 0)
        }
        .navigationTitle("Neue Überweisung")
    }
}
