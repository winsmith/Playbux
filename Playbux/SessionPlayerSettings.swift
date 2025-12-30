//
//  SessionPlayerSettings.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftUI

struct SessionPlayerSettings: View {
    @Bindable var player: Player

    var body: some View {
        Form {
            TextField("name", text: $player.name)
                .textContentType(.name)
        }
    }
}
