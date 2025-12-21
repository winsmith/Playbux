import Foundation
import SwiftData

@Model
final class BankBalance {
    var amount: Int
    var isInfinite: Bool

    var resourceType: ResourceType?

    init(amount: Int = 0, isInfinite: Bool = false) {
        self.amount = amount
        self.isInfinite = isInfinite
    }

    /// Convenience initializer for infinite bank supply (e.g., Monopoly).
    static func infinite() -> BankBalance {
        BankBalance(amount: 0, isInfinite: true)
    }

    /// Convenience initializer for finite bank supply (e.g., Catan resources).
    static func finite(_ amount: Int) -> BankBalance {
        BankBalance(amount: amount, isInfinite: false)
    }

    /// Returns true if the bank can provide the requested amount.
    func hasAvailable(_ amount: Int) -> Bool {
        isInfinite || self.amount >= amount
    }
}
