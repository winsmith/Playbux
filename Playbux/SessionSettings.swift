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
                TextField("Name", text: $session.name)
                    .textContentType(.name)
            }
            NavigationLink("Players", destination: SessionPlayersSettings(session: session))
            NavigationLink("Resourcen", destination: SessionResourcesSettings(session: session))

        }
    }
}
