import Foundation

struct GetTodayImpactUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute() async throws -> TodayImpact {
        let dates = ProgressDateRange.dates(for: .sevenDays, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        let today = logs.first { calendar.isDateInToday($0.date) }
        let weeklyAverage = ProgressAnalyticsCalculator.average(logs, metric: .calories)
        let todayCalories = today.map { ProgressAnalyticsCalculator.value(for: $0, metric: .calories) } ?? 0
        let todayNet = today.map { ProgressAnalyticsCalculator.netEnergyBalance(logs: [$0]) } ?? 0
        let todayScore = today.map { ProgressAnalyticsCalculator.adherence(logs: [$0], metric: .calories).hitRate } ?? 0
        return TodayImpact(weeklyAverageCaloriesContribution: todayCalories - weeklyAverage, weeklyNetEnergyBalanceContribution: todayNet, consistencyScoreContribution: todayScore)
    }
}
