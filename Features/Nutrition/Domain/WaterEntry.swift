import Foundation

/// Represents one immutable water intake event in a daily log.
final class WaterEntry: Identifiable {
    let id: UUID
    let amount: Double
    let timestamp: Date

    init(id: UUID = UUID(), amount: Double, timestamp: Date = Date()) {
        self.id = id
        self.amount = amount
        self.timestamp = timestamp
    }
}
