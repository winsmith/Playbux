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
                TextField("name", text: $resourceType.name)
                TextField("emoji", text: $resourceType.emoji)
            }

            Section {
                TextField("initial_player_amount", value: $resourceType.initialPlayerAmount, format: .number)
                #if os(iOS)
                    .keyboardType(.numberPad)
                #endif
            }
            header: { Text("initial_player_amount") }

            Section {
                TextField("bank_amount", value: $resourceType.initialBankAmount, format: .number)
                #if os(iOS)
                    .keyboardType(.numberPad)
                #endif
            }
            header: { Text("bank_amount") }
            footer: { Text("bank_amount_footer") }
        }
    }
}
