import Foundation
import HealthKit

/// HealthRepository implementation that keeps Apple Health APIs inside Infrastructure.
@MainActor
final class HealthKitRepository: HealthRepository {
    private let service: HealthKitService
    private let metadataStore: HealthSyncMetadataStore

    init(persistenceManager: PersistenceManager, service: HealthKitService? = nil) {
        self.service = service ?? HealthKitService()
        self.metadataStore = HealthSyncMetadataStore(persistenceManager: persistenceManager)
    }

    func requestPermissions(for dataTypes: Set<HealthDataType>) async throws { try await service.requestAuthorization(for: dataTypes) }
    func connectionStatus() async -> HealthConnectionStatus { service.authorizationStatus() }
    func importWeights(since date: Date?) async throws -> [WeightEntry] {
        let samples = try await service.weightSamples(since: date)
        try samples.forEach { try metadataStore.save(localID: $0.uuid, externalID: $0.uuid.uuidString, dataType: .weight, direction: .imported, status: .success) }
        return samples.map(HealthKitMapper.weight)
    }

    func importActiveEnergy(since date: Date?) async throws -> [ActiveEnergySample] {
        let samples = try await service.activeEnergySamples(since: date)
        try samples.forEach { try metadataStore.save(localID: $0.uuid, externalID: $0.uuid.uuidString, dataType: .activeEnergy, direction: .imported, status: .success) }
        return samples.map(HealthKitMapper.activeEnergy)
    }

    func importWorkouts(since date: Date?) async throws -> [HealthWorkout] {
        let samples = try await service.workouts(since: date)
        try samples.forEach { try metadataStore.save(localID: $0.uuid, externalID: $0.uuid.uuidString, dataType: .workouts, direction: .imported, status: .success) }
        return samples.map(HealthKitMapper.workout)
    }

    func exportNutrition(_ foods: [LoggedFood]) async throws {
        for food in foods where try metadataStore.metadata(localID: food.id, dataType: .nutrition) == nil {
            try await service.save(HealthKitMapper.nutritionSamples(from: food))
            try metadataStore.save(localID: food.id, externalID: food.id.uuidString, dataType: .nutrition, direction: .exported, status: .success)
        }
    }

    func exportWater(_ entries: [WaterEntry]) async throws {
        for entry in entries where try metadataStore.metadata(localID: entry.id, dataType: .water) == nil {
            guard let sample = HealthKitMapper.waterSample(from: entry) else { throw HealthRepositoryError.unavailable }
            try await service.save([sample])
            try metadataStore.save(localID: entry.id, externalID: entry.id.uuidString, dataType: .water, direction: .exported, status: .success)
        }
    }

    func exportWeight(_ entry: WeightEntry) async throws {
        guard try metadataStore.metadata(localID: entry.id, dataType: .weight) == nil, let sample = HealthKitMapper.weightSample(from: entry) else { return }
        try await service.save([sample])
        try metadataStore.save(localID: entry.id, externalID: entry.id.uuidString, dataType: .weight, direction: .exported, status: .success)
    }

    func lastSuccessfulSync(for dataType: HealthDataType) async throws -> Date? { try metadataStore.lastSuccessfulSync(for: dataType) }
    func disconnect() async throws { try metadataStore.removeAll() }
}
