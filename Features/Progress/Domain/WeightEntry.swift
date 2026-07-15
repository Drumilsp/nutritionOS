import Foundation

/// A recorded body-weight measurement at a point in time.
struct WeightEntry: Identifiable, Equatable {
    enum Source: String, Codable { case manual, healthKit, `import` }

    let id: UUID
    let weight: Double
    let recordedAt: Date
    let source: Source

    init(id: UUID = UUID(), weight: Double, recordedAt: Date = Date(), source: Source = .manual) {
        self.id = id
        self.weight = weight
        self.recordedAt = recordedAt
        self.source = source
    }
}
