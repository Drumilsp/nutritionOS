import Foundation

/// Restores an entry deleted in the current presentation interaction.
struct RestoreLoggedEntryUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository

    // MARK: - Initialization

    init(dailyLogRepository: any DailyLogRepository) {
        self.dailyLogRepository = dailyLogRepository
    }

    // MARK: - Public Methods

    func execute(_ entry: TimelineEntry, date: Date) async throws -> DailyLog {
        switch entry {
        case .food(let food):
            return try await dailyLogRepository.addLoggedFood(food, to: date)
        case .meal(let meal):
            return try await dailyLogRepository.addLoggedMeal(meal, to: date)
        case .water(let water):
            return try await dailyLogRepository.addWaterEntry(water, to: date)
        }
    }
}
