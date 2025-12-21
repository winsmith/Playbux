import Foundation
import SwiftData

@Model
final class Transaction {
    var timestamp: Date
    var amount: Int
    var note: String?

    var session: Session?
    var resourceType: ResourceType?
    var fromPlayer: Player?
    var toPlayer: Player?

    init(
        amount: Int,
        resourceType: ResourceType? = nil,
        fromPlayer: Player? = nil,
        toPlayer: Player? = nil,
        note: String? = nil,
        timestamp: Date = Date()
    ) {
        self.amount = amount
        self.resourceType = resourceType
        self.fromPlayer = fromPlayer
        self.toPlayer = toPlayer
        self.note = note
        self.timestamp = timestamp
    }

    /// True if this transaction is from the bank (no fromPlayer).
    var isFromBank: Bool {
        fromPlayer == nil
    }

    /// True if this transaction is to the bank (no toPlayer).
    var isToBank: Bool {
        toPlayer == nil
    }

    /// Human-readable description of the transaction.
    var summary: String {
        let resource = resourceType?.displayName ?? "resources"
        let from = fromPlayer?.name ?? "Bank"
        let to = toPlayer?.name ?? "Bank"
        return "\(from) → \(to): \(amount) \(resource)"
    }
}
