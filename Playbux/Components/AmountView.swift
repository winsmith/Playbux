//
//  AmountView.swift
//  Playbux
//
//  Created by Daniel Jilg on 16.01.26.
//

import SwiftUI

struct AmountView: View {
    let resourceType: ResourceType
    let amount: Int

    var body: some View {
        HStack(spacing: 4) {
            Text("\(amount)")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            Text(resourceType.emoji)
                .font(.system(size: 18))
        }
        .foregroundStyle(amountColor)
    }

    private var amountColor: Color {
        amount < 0 ? .red : .green
    }
}
