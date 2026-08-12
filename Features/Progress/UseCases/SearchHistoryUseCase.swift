import Foundation

struct SearchHistoryUseCase {
    private let dailyLogRepository: any DailyLogRepository

    init(dailyLogRepository: any DailyLogRepository) { self.dailyLogRepository = dailyLogRepository }

    func execute(query: String, from startDate: Date, to endDate: Date) async throws -> [DailyLog] {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let logs = try await dailyLogRepository.logs(from: startDate, to: endDate)
        guard !normalized.isEmpty else { return logs.sorted { $0.date > $1.date } }
        return logs.filter { log in
            log.loggedFoods.contains { $0.foodName.localizedCaseInsensitiveContains(normalized) || ($0.notes?.localizedCaseInsensitiveContains(normalized) ?? false) }
                || log.loggedMeals.contains { $0.mealName.localizedCaseInsensitiveContains(normalized) || ($0.notes?.localizedCaseInsensitiveContains(normalized) ?? false) }
                || (log.notes?.localizedCaseInsensitiveContains(normalized) ?? false)
        }.sorted { $0.date > $1.date }
    }
}
