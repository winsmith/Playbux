//
//  NewTransactionView.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct NewTransactionView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var fromPlayer: Player

    @State var toPlayer: Player?
    @State var resourceType: ResourceType?
    @State var amount: Int = 0
    @State var note: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(fromPlayer.name)
                }
                header: { Text("from") }

                Section {
                    Picker(String(localized: "recipient"), selection: $toPlayer) {
                        Text("bank").tag(nil as Player?)
                        Divider()
                        ForEach(fromPlayer.session?.players ?? [], id: \.self) { player in
                            // FIXME: Picker: the selection "Optional(Playbux.Player)" is invalid and does not have an associated tag, this will give undefined results.
                            Text(player.name).tag(player)
                        }
                    }
                }
                header: { Text("to") }

                Section {
                    Picker(String(localized: "currency"), selection: $resourceType) {
                        Text("please_select_currency").tag(nil as ResourceType?)
                        Divider()
                        ForEach(fromPlayer.session?.resourceTypes ?? [], id: \.self) { resourceType in
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
                    guard let resourceType else { return }

                    var savedNote: String? = nil
                    if note.isEmpty {
                    } else {
                        savedNote = note
                    }

                    // save transaction
                    fromPlayer.session?.createNewTransaction(
                        from: fromPlayer,
                        to: toPlayer,
                        resourceType: resourceType,
                        amount: amount,
                        note: savedNote
                    )

                    // dismiss sheet
                    dismiss()
                }
                .disabled(resourceType == nil && amount <= 0)
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
