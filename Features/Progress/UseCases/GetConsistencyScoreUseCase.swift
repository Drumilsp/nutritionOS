import Foundation

struct GetConsistencyScoreUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute(for range: ProgressTimeRange) async throws -> ConsistencyScore {
        let dates = ProgressDateRange.dates(for: range, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        let expectedDays = range.dayCount ?? max(calendar.dateComponents([.day], from: logs.map(\.date).min() ?? dates.end, to: dates.end).day ?? 0, 1)
        let adherence = ProgressAnalyticsCalculator.adherence(logs: logs, metric: .calories).hitRate
        let protein = ProgressAnalyticsCalculator.adherence(logs: logs, metric: .protein).hitRate
        let water = ProgressAnalyticsCalculator.adherence(logs: logs, metric: .water).hitRate
        let logging = min(Double(logs.count) / Double(expectedDays), 1)
        return ConsistencyScore(value: Int(((adherence + protein + water + logging) / 4 * 100).rounded()))
    }
}
