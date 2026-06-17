//
//  SessionPackageCell.swift
//  Playbux
//
//  Created by Daniel Jilg on 15.06.26.
//

import SwiftUI

/// A circular glass badge displaying a single emoji, optionally tinted.
private struct EmojiCircle: View {
    let emoji: String
    var color: Color? = nil

    private var glass: Glass {
        guard let color else { return .clear }
        return .clear.tint(color)
    }

    var body: some View {
        ZStack {
            Circle()
                .glassEffect(glass)
            Text(emoji)
                .font(.largeTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.01)
                .padding(4)
        }
    }
}

/// Cool little display cell for a session with game name and resource types.
struct SessionPackageCell: View {
    /// Maximum number of player/resource badges shown before truncating.
    private static let maxBadges = 10

    let session: Session

    private var players: [Player] {
        Array(session.players.prefix(Self.maxBadges))
    }

    private var resources: [ResourceType] {
        Array(session.resourceTypes.prefix(Self.maxBadges))
    }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                BoxImageBackground(session: session)
                VStack {
                    HStack {
                        ForEach(players) { player in
                            EmojiCircle(emoji: player.emoji, color: player.color)
                                .frame(maxWidth: 44, maxHeight: 44)
                        }
                    }
                    Spacer()
                    HStack {
                        ForEach(resources) { resource in
                            EmojiCircle(emoji: resource.emoji)
                                .frame(maxWidth: 32, maxHeight: 32)
                        }
                    }
                }
                .padding(8)
                .frame(maxHeight: .infinity)
            }
            .frame(
                minWidth: 50, idealWidth: 100, maxWidth: 150,
                minHeight: 50, idealHeight: 100, maxHeight: 150
            )

            Text(session.name)
                .padding()
        }
    }
}

#Preview("Cell", traits: .sizeThatFitsLayout) {
    let session = Session(name: "Das Spiel des Siedelns", createdAt: Date())
    session.resourceTypes = [
        ResourceType(name: "Holz", emoji: "🪵"),
        ResourceType(name: "Stein", emoji: "🪨"),
        ResourceType(name: "Schafe", emoji: "🐑"),
        ResourceType(name: "Lehm", emoji: "🧱"),
        ResourceType(name: "Getreide", emoji: "🌾"),
        ResourceType(name: "Schafe", emoji: "🐑"),
        ResourceType(name: "Lehm", emoji: "🧱"),
        ResourceType(name: "Getreide", emoji: "🌾"),
    ]
    session.players = [
        Player(name: "Onkidonk", emoji: "🏳️‍🌈", displayOrder: 1, colorHex: "#da0a57"),
        Player(name: "ColorHex", emoji: "🧙", displayOrder: 2, colorHex: "#93668c"),
        Player(name: "Lol Carla", emoji: "🫎", displayOrder: 3, colorHex: "#bb90d9"),
    ]
    return SessionPackageCell(session: session)
}
