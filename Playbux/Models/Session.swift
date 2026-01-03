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
        for resourceType in self.resourceTypes {
            for player in self.players {
                let newBalance = PlayerBalance(player: player, resourceType: resourceType, amount: resourceType.initialPlayerAmount)
                player.balances.append(newBalance)
            }
        }

        self.isStarted = true
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
        self.transactions.append(myNewTransaction)

        fromPlayer?.balances.forEach { balance in
            if balance.resourceType == resourceType {
                balance.amount -= amount
            }
        }

        toPlayer?.balances.forEach { balance in
            if balance.resourceType == resourceType {
                balance.amount += amount
            }
        }
    }
}
