import Foundation

/// Provides persistence operations for recorded body-weight measurements.
protocol WeightRepository {
    func save(_ entry: WeightEntry) async throws -> WeightEntry
    func entries(from startDate: Date?, to endDate: Date?) async throws -> [WeightEntry]
    func delete(id: UUID) async throws
}
