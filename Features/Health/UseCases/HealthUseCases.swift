import Foundation

/// Requests only the Apple Health categories selected by the user.
struct RequestHealthPermissionsUseCase {
    private let healthRepository: any HealthRepository
    init(healthRepository: any HealthRepository) { self.healthRepository = healthRepository }
    func execute(for dataTypes: Set<HealthDataType>) async throws { try await healthRepository.requestPermissions(for: dataTypes) }
}

/// Reads the current optional Apple Health connection state for Settings.
struct GetHealthConnectionStatusUseCase {
    private let healthRepository: any HealthRepository
    init(healthRepository: any HealthRepository) { self.healthRepository = healthRepository }
    func execute() async -> HealthConnectionStatus { await healthRepository.connectionStatus() }
}

/// Imports HealthKit weights, keeping the newest timestamp as the current value.
struct ImportWeightUseCase {
    private let healthRepository: any HealthRepository
    private let weightRepository: any WeightRepository
    init(healthRepository: any HealthRepository, weightRepository: any WeightRepository) { self.healthRepository = healthRepository; self.weightRepository = weightRepository }
    func execute() async throws -> [WeightEntry] {
        let lastSync = try await healthRepository.lastSuccessfulSync(for: .weight)
        let imported = try await healthRepository.importWeights(since: lastSync)
        let localLatest = try await weightRepository.latest()
        return try await withThrowingTaskGroup(of: WeightEntry.self) { group in
            for entry in imported where localLatest.map({ $0.recordedAt < entry.recordedAt }) ?? true {
                group.addTask { try await self.weightRepository.save(WeightEntry(weight: entry.weight, recordedAt: entry.recordedAt, source: .healthKit)) }
            }
            var saved: [WeightEntry] = []
            for try await entry in group { saved.append(entry) }
            return saved
        }
    }
}

/// Imports newly recorded Apple Health active-energy samples.
struct ImportActiveEnergyUseCase {
    private let healthRepository: any HealthRepository
    init(healthRepository: any HealthRepository) { self.healthRepository = healthRepository }
    func execute() async throws -> [ActiveEnergySample] { try await healthRepository.importActiveEnergy(since: try await healthRepository.lastSuccessfulSync(for: .activeEnergy)) }
}

/// Imports newly recorded Apple Health workouts as read-only contextual data.
struct ImportWorkoutsUseCase {
    private let healthRepository: any HealthRepository
    init(healthRepository: any HealthRepository) { self.healthRepository = healthRepository }
    func execute() async throws -> [HealthWorkout] { try await healthRepository.importWorkouts(since: try await healthRepository.lastSuccessfulSync(for: .workouts)) }
}

/// Exports individual immutable logged-food snapshots to Apple Health.
struct ExportNutritionUseCase {
    private let healthRepository: any HealthRepository
    init(healthRepository: any HealthRepository) { self.healthRepository = healthRepository }
    func execute(_ foods: [LoggedFood]) async throws { try await healthRepository.exportNutrition(foods) }
}

/// Exports individual water events to Apple Health.
struct ExportWaterUseCase {
    private let healthRepository: any HealthRepository
    init(healthRepository: any HealthRepository) { self.healthRepository = healthRepository }
    func execute(_ entries: [WaterEntry]) async throws { try await healthRepository.exportWater(entries) }
}

/// Coordinates a user-triggered incremental synchronization without chaining use cases.
struct SyncHealthDataUseCase {
    private let healthRepository: any HealthRepository
    private let weightRepository: (any WeightRepository)?
    private let dailyLogRepository: (any DailyLogRepository)?
    init(healthRepository: any HealthRepository, weightRepository: (any WeightRepository)? = nil, dailyLogRepository: (any DailyLogRepository)? = nil) { self.healthRepository = healthRepository; self.weightRepository = weightRepository; self.dailyLogRepository = dailyLogRepository }
    func execute() async throws {
        let weights = try await healthRepository.importWeights(since: try await healthRepository.lastSuccessfulSync(for: .weight))
        if let weightRepository {
            let latestLocalWeight = try await weightRepository.latest()
            for weight in weights where latestLocalWeight.map({ $0.recordedAt < weight.recordedAt }) ?? true { _ = try await weightRepository.save(weight) }
        }
        let energy = try await healthRepository.importActiveEnergy(since: try await healthRepository.lastSuccessfulSync(for: .activeEnergy))
        if let dailyLogRepository {
            for sample in energy {
                let log = try await dailyLogRepository.log(date: sample.date)
                log.activeCalories = sample.kilocalories
                log.updatedAt = Date()
                _ = try await dailyLogRepository.save(log)
            }
        }
        _ = try await healthRepository.importWorkouts(since: try await healthRepository.lastSuccessfulSync(for: .workouts))
    }
}

/// Removes only local synchronization metadata; it never deletes Nutrition OS history.
struct DisconnectHealthUseCase {
    private let healthRepository: any HealthRepository
    init(healthRepository: any HealthRepository) { self.healthRepository = healthRepository }
    func execute() async throws { try await healthRepository.disconnect() }
}
