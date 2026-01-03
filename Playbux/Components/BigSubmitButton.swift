//
//  BigSubmitButton.swift
//  Playbux
//
//  Created by Daniel Jilg on 03.01.26.
//

import SwiftUI

struct BigSubmitButton: View {
    let title: LocalizedStringKey
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(isDisabled)
    }
}

#Preview {
    BigSubmitButton(title: "Submit", isDisabled: false) {
        print("Submitted")
    }
    .padding()
}
