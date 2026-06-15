//
//  SessionPackageCell.swift
//  Playbux
//
//  Created by Daniel Jilg on 15.06.26.
//

import SwiftUI

struct EmojiCircle: View {
    let emoji: String
    let color: Color?
    
    var body: some View  {
        ZStack {
//            Circle()
//                .fill(color?.opacity(0.9) ?? Color.white.opacity(0.5))
//                .padding(1)
            Text(emoji)
                .scaledToFill()
                .minimumScaleFactor(0.01)
            
                .glassEffect(.regular.tint(color ?? .white.opacity(0.2)).interactive())
        }
    }
}

/// Cool little display cell for a session with game name and resource types
struct SessionPackageCell: View {
    let session: Session
    
    let playersLayout = [
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
    ]
    
    let resourcesLayout = [
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
        GridItem(.adaptive(minimum: 10, maximum: 30)),
    ]
    
    var players: [Player] {
        return Array(session.players.prefix(10))
    }
    
    var ressources: [ResourceType] {
        return Array(session.resourceTypes.prefix(10))
    }
    
    var playerColors: [Color] {
        var colors: [Color] = []
        for player in players {
            colors.append(player.color)
        }
        colors.append(players[0].color)
        return colors
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12.0, style: .circular)
                .fill(
                    RadialGradient(colors: players.map { $0.color }, center: .bottom, startRadius: 0, endRadius: 200)
//                    AngularGradient(colors: playerColors, center: .center)
//                    LinearGradient(colors: playerColors, startPoint: .leading, endPoint: .trailing)
                )
            VStack {
                LazyVGrid(columns: playersLayout) {
                    ForEach(players) { player in
                        EmojiCircle(emoji: player.emoji, color: player.color)
                    }
                }
                Spacer()
                LazyVGrid(columns: resourcesLayout) {
                    ForEach(ressources) { resourceType in
                        EmojiCircle(emoji: resourceType.emoji, color: nil)
                    }
                }
            }
            .padding(8.0)
            .frame(maxHeight: .infinity)
        }
        .frame(minWidth: 50, idealWidth: 100, maxWidth: 150, minHeight: 50, idealHeight: 100, maxHeight: 150, alignment: .center)
        Text(session.name).foregroundStyle(.cyan)
    }
}

#Preview("Cell", traits: .sizeThatFitsLayout) {
    let session = Session(name: "Das Spiel des Siedelns", createdAt: Date())
    session.resourceTypes = [
        .Root(name: "Holz", emoji: "🪵"),
        .Root(name: "Stein", emoji: "🪨"),
        .Root(name: "Schafe", emoji: "🐑"),
        .Root(name: "Lehm", emoji: "🧱"),
        .Root(name: "Getreide", emoji: "🌾"),
        .Root(name: "Schafe", emoji: "🐑"),
        .Root(name: "Lehm", emoji: "🧱"),
        .Root(name: "Getreide", emoji: "🌾"),
    ]
    session.players = [
        .init(name: "Onkidonk", emoji: "🏳️‍🌈", displayOrder: 1, colorHex: "#da0a57"),
        .init(name: "ColorHex", emoji: "🧙", displayOrder: 2, colorHex: "#93668c"),
        .init(name: "Lol Carla", emoji: "🫎", displayOrder: 3, colorHex: "#bb90d9"),
    ]
    return SessionPackageCell(session: session)
}
