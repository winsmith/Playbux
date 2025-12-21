import Foundation
import SwiftData

@Model
final class ResourceType {
    var name: String
    var emoji: String?
    var initialBankAmount: Int?
    var initialPlayerAmount: Int
    var displayOrder: Int

    var session: Session?

    @Relationship(deleteRule: .cascade, inverse: \BankBalance.resourceType)
    var bankBalance: BankBalance?

    @Relationship(inverse: \PlayerBalance.resourceType)
    var playerBalances: [PlayerBalance] = []

    init(
        name: String,
        emoji: String? = nil,
        initialBankAmount: Int? = nil,
        initialPlayerAmount: Int = 0,
        displayOrder: Int = 0
    ) {
        self.name = name
        self.emoji = emoji
        self.initialBankAmount = initialBankAmount
        self.initialPlayerAmount = initialPlayerAmount
        self.displayOrder = displayOrder
    }

    /// Display name with optional emoji prefix.
    var displayName: String {
        if let emoji = emoji {
            return "\(emoji) \(name)"
        }
        return name
    }

    /// Returns true if the bank has the requested amount available (or is infinite).
    func bankHasAvailable(_ amount: Int) -> Bool {
        guard let balance = bankBalance else { return false }
        return balance.isInfinite || balance.amount >= amount
    }

    /// Current bank amount, or nil if infinite.
    var currentBankAmount: Int? {
        guard let balance = bankBalance else { return nil }
        return balance.isInfinite ? nil : balance.amount
    }
}
