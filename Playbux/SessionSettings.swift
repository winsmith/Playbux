//
//  SessionSettings.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct SessionSettings: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var session: Session

    var body: some View {
        Form {
            Section {
                TextField("name", text: $session.name)
                    .textContentType(.name)
            }
            NavigationLink(String(localized: "players"), destination: SessionPlayersSettings(session: session))
            NavigationLink(String(localized: "resources"), destination: SessionResourcesSettings(session: session))

        }
    }
}
