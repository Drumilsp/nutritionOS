import Foundation
import HealthKit
import Testing
@testable import Nutri

struct HealthKitTests {

    @MainActor
    @Test func permissionUseCaseForwardsSelectedDataTypesToRepository() async throws {
        let repository = HealthRepositorySpy()
        let selected: Set<HealthDataType> = [.weight, .nutrition]

        try await RequestHealthPermissionsUseCase(healthRepository: repository).execute(for: selected)

        #expect(repository.requestedTypes == selected)
    }

    @Test func mapperConvertsWeightAndNutritionSamples() {
        let timestamp = Date(timeIntervalSince1970: 1_000)
        let weightSample = HKQuantitySample(
            type: HKQuantityType(.bodyMass),
            quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 72.5),
            start: timestamp,
            end: timestamp
        )
        let food = LoggedFood(
            id: UUID(),
            foodName: "Oats",
            referenceQuantity: 100,
            referenceUnit: .grams,
            loggedQuantity: 100,
            nutritionProfileSnapshot: NutritionProfile(nutrientValues: [
                NutrientValue(nutrientType: .calories, value: 150, unit: .kilocalories)
            ]),
            createdAt: timestamp
        )

        #expect(HealthKitMapper.weight(weightSample).weight == 72.5)
        #expect(HealthKitMapper.weight(weightSample).recordedAt == timestamp)
        #expect(HealthKitMapper.nutritionSamples(from: food).count == 1)
    }

    @MainActor
    @Test func syncMetadataPersistsAndFindsLatestSuccessfulSync() throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let store = HealthSyncMetadataStore(persistenceManager: dependencies.persistenceManager)
        let localID = UUID()

        try store.save(localID: localID, externalID: "external-weight", dataType: .weight, direction: .imported, status: .success)

        #expect(try store.metadata(localID: localID, dataType: .weight)?.externalID == "external-weight")
        #expect(try store.lastSuccessfulSync(for: .weight) != nil)
    }

    @MainActor
    @Test func incrementalSyncUsesCheckpointAndPreventsDuplicateWeights() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let repository = HealthRepositorySpy()
        let timestamp = Date(timeIntervalSince1970: 2_000)
        repository.weights = [WeightEntry(id: UUID(), weight: 71.2, recordedAt: timestamp, source: .healthKit)]
        repository.lastSync[.weight] = Date(timeIntervalSince1970: 1_000)
        let useCase = SyncHealthDataUseCase(healthRepository: repository, weightRepository: dependencies.weightRepository)

        try await useCase.execute()
        try await useCase.execute()

        #expect(repository.weightSinceArguments == [Date(timeIntervalSince1970: 1_000), Date(timeIntervalSince1970: 1_000)])
        #expect(try await dependencies.weightRepository.entries(from: nil, to: nil).count == 1)
    }
}

@MainActor
private final class HealthRepositorySpy: HealthRepository {
    var requestedTypes: Set<HealthDataType> = []
    var weights: [WeightEntry] = []
    var activeEnergy: [ActiveEnergySample] = []
    var workouts: [HealthWorkout] = []
    var lastSync: [HealthDataType: Date] = [:]
    var weightSinceArguments: [Date?] = []

    func requestPermissions(for dataTypes: Set<HealthDataType>) async throws { requestedTypes = dataTypes }
    func connectionStatus() async -> HealthConnectionStatus { .connected }
    func importWeights(since date: Date?) async throws -> [WeightEntry] { weightSinceArguments.append(date); return weights }
    func importActiveEnergy(since date: Date?) async throws -> [ActiveEnergySample] { activeEnergy }
    func importWorkouts(since date: Date?) async throws -> [HealthWorkout] { workouts }
    func exportNutrition(_ foods: [LoggedFood]) async throws { }
    func exportWater(_ entries: [WaterEntry]) async throws { }
    func exportWeight(_ entry: WeightEntry) async throws { }
    func lastSuccessfulSync(for dataType: HealthDataType) async throws -> Date? { lastSync[dataType] }
    func disconnect() async throws { }
}
