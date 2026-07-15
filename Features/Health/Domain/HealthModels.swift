import Foundation

/// A user-selectable Apple Health data category.
enum HealthDataType: String, CaseIterable, Codable, Hashable {
    case weight
    case activeEnergy
    case workouts
    case nutrition
    case water
}

/// The direction in which a record was synchronized.
enum HealthSyncDirection: String, Codable {
    case imported
    case exported
}

/// The persisted outcome of a single record synchronization.
enum HealthSyncStatus: String, Codable {
    case success
    case failed
}

/// A domain-friendly state for the optional Apple Health connection.
enum HealthConnectionStatus: Equatable {
    case connected
    case disconnected
    case permissionDenied
    case unavailable
    case syncing
    case error(String)
}

/// A HealthKit-independent workout imported for contextual display.
struct HealthWorkout: Identifiable, Equatable {
    let id: String
    let activityType: String
    let startDate: Date
    let endDate: Date
    let activeEnergyKilocalories: Double?

    var duration: TimeInterval { endDate.timeIntervalSince(startDate) }
}

/// A HealthKit-independent active-energy measurement.
struct ActiveEnergySample: Identifiable, Equatable {
    let id: String
    let date: Date
    let kilocalories: Double
}

/// Metadata that prevents a local record from being exported more than once.
struct HealthSyncMetadata: Identifiable, Equatable {
    let id: UUID
    let localID: UUID
    let externalID: String
    let dataType: HealthDataType
    let lastSyncedAt: Date
    let direction: HealthSyncDirection
    let status: HealthSyncStatus
}

/// Errors safe to present outside the HealthKit infrastructure boundary.
enum HealthRepositoryError: Error {
    case unavailable
    case permissionDenied
    case noData
    case synchronizationFailed
}
