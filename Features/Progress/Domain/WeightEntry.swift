import Foundation

/// A recorded body-weight measurement at a point in time.
struct WeightEntry: Identifiable, Equatable {
    let id: UUID
    let weight: Double
    let recordedAt: Date

    init(id: UUID = UUID(), weight: Double, recordedAt: Date = Date()) {
        self.id = id
        self.weight = weight
        self.recordedAt = recordedAt
    }
}
