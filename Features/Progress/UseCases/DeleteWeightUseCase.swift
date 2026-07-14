import Foundation

struct DeleteWeightUseCase {
    private let weightRepository: any WeightRepository

    init(weightRepository: any WeightRepository) { self.weightRepository = weightRepository }

    func execute(id: UUID) async throws { try await weightRepository.delete(id: id) }
}
