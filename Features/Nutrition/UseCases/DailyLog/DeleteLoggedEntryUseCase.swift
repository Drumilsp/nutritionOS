import Foundation

struct DeleteLoggedEntryUseCase {
    private let dailyLogRepository: any DailyLogRepository
    init(dailyLogRepository: any DailyLogRepository) { self.dailyLogRepository = dailyLogRepository }
    func execute(_ entry: TimelineEntry, date: Date) async throws -> DailyLog {
        switch entry { case .food(let food): return try await dailyLogRepository.removeLoggedFood(id: food.id, from: date); case .meal(let meal): return try await dailyLogRepository.removeLoggedMeal(id: meal.id, from: date); case .water(let water): return try await dailyLogRepository.removeWaterEntry(id: water.id, from: date) }
    }
}
