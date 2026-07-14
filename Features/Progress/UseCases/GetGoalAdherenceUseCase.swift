import Foundation

struct GetGoalAdherenceUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute(for range: ProgressTimeRange) async throws -> [GoalAdherence] {
        let dates = ProgressDateRange.dates(for: range, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        return ProgressMetric.allCases.filter { $0 != .weight }.map { ProgressAnalyticsCalculator.adherence(logs: logs, metric: $0) }
    }
}
