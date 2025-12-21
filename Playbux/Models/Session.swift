import Foundation
import SwiftData

@Model
final class Session {
    var name: String
    var createdAt: Date

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
}
