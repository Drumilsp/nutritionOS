import Foundation
import SwiftData

/// SwiftData representation of a recorded body-weight measurement.
@Model
final class WeightEntryEntity {
    var id: UUID
    var weight: Double
    var recordedAt: Date

    init(id: UUID, weight: Double, recordedAt: Date) {
        self.id = id
        self.weight = weight
        self.recordedAt = recordedAt
    }
}
