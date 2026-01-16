import Foundation
import SwiftData

@Model
final class Session {
    var name: String
    var createdAt: Date

    /// call startSession to start the session
    var isStarted: Bool = false

    @Relationship(deleteRule: .cascade, inverse: \Player.session)
    var players: [Player] = []

    @Relationship(deleteRule: .cascade, inverse: \ResourceType.session)
    var resourceTypes: [ResourceType] = []

    @Relationship(deleteRule: .cascade, inverse: \Transaction.session)
    var transactions: [Transaction] = []

    init(name: String, createdAt: Date = Date()) {
        self.name = name
        self.createdAt = createdAt
    }

    /// Begin the game and create empty balances
    func startSession() {
        for resourceType in resourceTypes {
            for player in players {
                let newBalance = PlayerBalance(player: player, resourceType: resourceType, amount: resourceType.initialPlayerAmount)
                player.balances.append(newBalance)
            }
        }

        isStarted = true
    }

    /// Pool of fun example resource types for random selection
    private static let exampleResourceTypes: [(name: String, emoji: String)] = [
        // Food & Drink
        ("Pizza", "🍕"),
        ("Cookies", "🍪"),
        ("Tacos", "🌮"),
        ("Coffee", "☕"),
        ("Donuts", "🍩"),
        ("Beer", "🍺"),
        // Fantasy/RPG
        ("Gold", "🪙"),
        ("Gems", "💎"),
        ("Mana", "✨"),
        ("XP", "⭐"),
        ("Potions", "🧪"),
        ("Souls", "👻"),
        // Sci-Fi
        ("Credits", "💳"),
        ("Fuel", "⛽"),
        ("Energy", "⚡"),
        ("Ore", "🪨"),
        // Silly/Modern
        ("Clout", "📈"),
        ("Vibes", "🌊"),
        ("Karma", "☯️"),
        ("Schmeckles", "🥒"),
        ("Exposure", "📸"),
        // Seasonal
        ("Candy", "🍬"),
        ("Presents", "🎁"),
        ("Eggs", "🥚"),
        // Games
        ("Chips", "🎰"),
        ("Points", "🎯"),
        ("Lives", "❤️"),
        ("Coins", "🟡"),
        // Catan
        ("Brick", "🧱"),
        ("Lumber", "🪵"),
        ("Wool", "🐑"),
        ("Grain", "🌾"),
        // Bonus
        ("Bucks", "🦌"),
    ]

    /// Returns the next example resource type - "Bucks" first, then random
    func nextExampleResourceType() -> ResourceType {
        if resourceTypes.isEmpty {
            return ResourceType(name: "Bucks", emoji: "💰")
        }
        let example = Self.exampleResourceTypes.randomElement()!
        return ResourceType(name: example.name, emoji: example.emoji)
    }

    /// Add a player to the session, creating their balances if the game has started
    func addPlayer(_ player: Player) {
        players.append(player)

        if isStarted {
            for resourceType in resourceTypes {
                let newBalance = PlayerBalance(
                    player: player,
                    resourceType: resourceType,
                    amount: resourceType.initialPlayerAmount
                )
                player.balances.append(newBalance)
            }
        }
    }

    func createNewTransaction(from fromPlayer: Player?, to toPlayer: Player?, resourceType: ResourceType, amount: Int, note: String? = nil) {
        let myNewTransaction = Transaction(amount: amount, resourceType: resourceType, fromPlayer: fromPlayer, toPlayer: toPlayer, note: note, timestamp: Date.now)
        transactions.append(myNewTransaction)

        fromPlayer?.balances.forEach { balance in
            if balance.resourceType?.id == resourceType.id {
                balance.amount -= amount
            }
        }

        toPlayer?.balances.forEach { balance in
            if balance.resourceType?.id == resourceType.id {
                balance.amount += amount
            }
        }
    }
}
