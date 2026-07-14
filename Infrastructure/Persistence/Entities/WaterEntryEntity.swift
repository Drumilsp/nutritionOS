import Foundation
import SwiftData

/// SwiftData representation of one water entry owned by a daily log.
@Model
final class WaterEntryEntity {
    var id: UUID
    var amount: Double
    var timestamp: Date

    init(id: UUID, amount: Double, timestamp: Date) {
        self.id = id
        self.amount = amount
        self.timestamp = timestamp
    }
}
