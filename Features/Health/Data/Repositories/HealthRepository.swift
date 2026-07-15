import Foundation

/// Adapts optional Apple Health operations for the domain and use-case layers.
protocol HealthRepository {
    func requestPermissions(for dataTypes: Set<HealthDataType>) async throws
    func connectionStatus() async -> HealthConnectionStatus
    func importWeights(since date: Date?) async throws -> [WeightEntry]
    func importActiveEnergy(since date: Date?) async throws -> [ActiveEnergySample]
    func importWorkouts(since date: Date?) async throws -> [HealthWorkout]
    func exportNutrition(_ foods: [LoggedFood]) async throws
    func exportWater(_ entries: [WaterEntry]) async throws
    func exportWeight(_ entry: WeightEntry) async throws
    func lastSuccessfulSync(for dataType: HealthDataType) async throws -> Date?
    func disconnect() async throws
}
