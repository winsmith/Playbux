import Foundation
import SwiftData

@Model
final class Player {
    var name: String
    var displayOrder: Int
    var colorHex: String

    var session: Session?

    @Relationship(deleteRule: .cascade, inverse: \PlayerBalance.player)
    var balances: [PlayerBalance] = []

    init(name: String, displayOrder: Int = 0, colorHex: String = "#007AFF") {
        self.name = name
        self.displayOrder = displayOrder
        self.colorHex = colorHex
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
