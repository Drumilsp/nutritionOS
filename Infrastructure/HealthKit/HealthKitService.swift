import Foundation
import HealthKit

/// Thin wrapper around HKHealthStore authorization, queries, writes, and deletes.
@MainActor
final class HealthKitService {
    private let healthStore = HKHealthStore()

    func isAvailable() -> Bool { HKHealthStore.isHealthDataAvailable() }

    func requestAuthorization(for types: Set<HealthDataType>) async throws {
        guard isAvailable() else { throw HealthRepositoryError.unavailable }
        let read = Set(types.compactMap(readType))
        let write = Set(types.compactMap(writeType))
        try await healthStore.requestAuthorization(toShare: write, read: read)
    }

    func authorizationStatus() -> HealthConnectionStatus {
        guard isAvailable() else { return .unavailable }
        let writable = [HKObjectType.quantityType(forIdentifier: .bodyMass), HKObjectType.quantityType(forIdentifier: .dietaryWater)]
            .compactMap { $0 }
        if writable.contains(where: { healthStore.authorizationStatus(for: $0) == .sharingDenied }) {
            return .permissionDenied
        }
        return .connected
    }

    func weightSamples(since date: Date?) async throws -> [HKQuantitySample] {
        try await quantitySamples(type: .bodyMass, since: date)
    }

    func activeEnergySamples(since date: Date?) async throws -> [HKQuantitySample] {
        try await quantitySamples(type: .activeEnergyBurned, since: date)
    }

    func workouts(since date: Date?) async throws -> [HKWorkout] {
        let predicate = date.map { HKQuery.predicateForSamples(withStart: $0, end: nil, options: .strictStartDate) }
        let descriptor = HKSampleQueryDescriptor(predicates: [.workout(predicate)], sortDescriptors: [SortDescriptor(\.startDate)])
        return try await descriptor.result(for: healthStore)
    }

    func save(_ samples: [HKSample]) async throws {
        guard isAvailable() else { throw HealthRepositoryError.unavailable }
        try await healthStore.save(samples)
    }

    func deleteSample(with identifier: String) async throws {
        guard let uuid = UUID(uuidString: identifier) else { return }
        let predicate = HKQuery.predicateForObject(with: uuid)
        try await healthStore.deleteObjects(of: HKObjectType.quantityType(forIdentifier: .bodyMass)!, predicate: predicate)
    }

    private func quantitySamples(type identifier: HKQuantityTypeIdentifier, since date: Date?) async throws -> [HKQuantitySample] {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier) else { throw HealthRepositoryError.unavailable }
        let predicate = date.map { HKQuery.predicateForSamples(withStart: $0, end: nil, options: .strictStartDate) }
        let descriptor = HKSampleQueryDescriptor(predicates: [.quantitySample(type: type, predicate: predicate)], sortDescriptors: [SortDescriptor(\.startDate)])
        return try await descriptor.result(for: healthStore)
    }

    private func readType(for type: HealthDataType) -> HKObjectType? {
        switch type {
        case .weight: HKObjectType.quantityType(forIdentifier: .bodyMass)
        case .activeEnergy: HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        case .workouts: HKObjectType.workoutType()
        case .nutrition, .water: nil
        }
    }

    private func writeType(for type: HealthDataType) -> HKSampleType? {
        switch type {
        case .weight: HKObjectType.quantityType(forIdentifier: .bodyMass)
        case .nutrition: HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        case .water: HKObjectType.quantityType(forIdentifier: .dietaryWater)
        case .activeEnergy, .workouts: nil
        }
    }
}
