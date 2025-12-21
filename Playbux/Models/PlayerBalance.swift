import Foundation
import SwiftData

@Model
final class PlayerBalance {
    var amount: Int

    var player: Player?
    var resourceType: ResourceType?

    init(amount: Int = 0) {
        self.amount = amount
    }

    init(player: Player, resourceType: ResourceType, amount: Int) {
        self.player = player
        self.resourceType = resourceType
        self.amount = amount
    }
}
