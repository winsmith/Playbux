import Foundation
import SwiftData

@Model
final class Player {
    var name: String
    var emoji: String
    var displayOrder: Int
    var colorHex: String

    var session: Session?

    @Relationship(deleteRule: .cascade, inverse: \PlayerBalance.player)
    var balances: [PlayerBalance] = []

    /// Pool of fun player emojis for random selection
    static let emojiPool = ["🎮", "👤", "🧑", "👩", "👨", "🦸", "🧙", "🤖", "🎭", "🐱", "🐶", "🦊", "🐼", "🦄", "🐲", "🎯", "⭐", "🌟", "🔥", "💎", "🎪", "🎨", "🎵", "🚀", "🌈"]

    init(name: String, emoji: String? = nil, displayOrder: Int = 0, colorHex: String = "#007AFF") {
        self.name = name
        self.emoji = emoji ?? Self.emojiPool.randomElement()!
        self.displayOrder = displayOrder
        self.colorHex = colorHex
    }

    /// Display name with emoji prefix
    var displayName: String {
        "\(emoji) \(name)"
    }

    /// Returns the player's balance for a specific resource type, or 0 if not found.
    func balance(for resourceType: ResourceType) -> Int {
        balances.first { $0.resourceType === resourceType }?.amount ?? 0
    }

    /// Returns the PlayerBalance object for a specific resource type, if it exists.
    func playerBalance(for resourceType: ResourceType) -> PlayerBalance? {
        balances.first { $0.resourceType === resourceType }
    }
}
