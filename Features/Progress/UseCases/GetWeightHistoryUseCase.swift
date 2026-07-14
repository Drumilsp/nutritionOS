import Foundation

struct GetWeightHistoryUseCase {
    private let weightRepository: any WeightRepository

    init(weightRepository: any WeightRepository) { self.weightRepository = weightRepository }

    func execute(from startDate: Date? = nil, to endDate: Date? = nil) async throws -> [WeightEntry] {
        try await weightRepository.entries(from: startDate, to: endDate)
    }
}
