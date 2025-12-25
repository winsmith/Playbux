//
//  SessionView.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct SessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var session: Session

    var body: some View {

            List {
                NavigationLink("Einstellungen", destination: SessionSettings(session: session))
            }
            .navigationTitle(session.name)

    }
}
