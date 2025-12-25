//
//  SessionPlayerSettings.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct SessionResourceTypeSettings: View {
    @Bindable var resourceType: ResourceType

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $resourceType.name)
                TextField("Emoji", text: $resourceType.emoji)
            }

            Section {
                TextField("Initial Player amount", value: $resourceType.initialPlayerAmount, format: .number)
                    .keyboardType(.numberPad)
            }
            header: { Text("Startbetrag pro Spieler*in") }

            Section {
                TextField("Initial Bank amount", value: $resourceType.initialBankAmount, format: .number)
                    .keyboardType(.numberPad)
            }
            header: { Text("Betrag in der Bank") }
            footer: { Text("Kann auch leer sein, dann hat die Bank unendlich Geld") }
        }
    }
}
