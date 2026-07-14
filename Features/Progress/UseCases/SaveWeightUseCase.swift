import Foundation

struct SaveWeightUseCase {
    private let weightRepository: any WeightRepository

    init(weightRepository: any WeightRepository) { self.weightRepository = weightRepository }

    func execute(weight: Double, recordedAt: Date = Date()) async throws -> WeightEntry {
        guard weight > 0, weight.isFinite else { throw RepositoryError.persistenceFailure }
        return try await weightRepository.save(WeightEntry(weight: weight, recordedAt: recordedAt))
    }
}
