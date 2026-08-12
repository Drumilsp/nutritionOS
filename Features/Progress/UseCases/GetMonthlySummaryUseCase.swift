import Foundation

struct GetMonthlySummaryUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let weightRepository: any WeightRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, weightRepository: any WeightRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.weightRepository = weightRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute() async throws -> MonthlySummary {
        let dates = ProgressDateRange.dates(for: .thirtyDays, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        let weights = try await weightRepository.entries(from: dates.start, to: dates.end)
        let previous = ProgressDateRange.previousDates(for: .thirtyDays, now: dateProvider.now, calendar: calendar)
        let previousWeights = try await weightRepository.entries(from: previous?.start, to: previous?.end)
        return MonthlySummary(averageCalories: ProgressAnalyticsCalculator.average(logs, metric: .calories), averageProtein: ProgressAnalyticsCalculator.average(logs, metric: .protein), averageCarbohydrates: ProgressAnalyticsCalculator.average(logs, metric: .carbohydrates), averageFat: ProgressAnalyticsCalculator.average(logs, metric: .fat), averageFibre: ProgressAnalyticsCalculator.average(logs, metric: .fibre), averageWater: ProgressAnalyticsCalculator.average(logs, metric: .water), goalAdherence: ProgressMetric.allCases.filter { $0 != .weight && $0 != .fibre }.map { ProgressAnalyticsCalculator.adherence(logs: logs, metric: $0) }, weightTrend: weights.isEmpty ? nil : ProgressAnalyticsCalculator.trend(metric: .weight, currentLogs: [], previousLogs: [], currentWeights: weights, previousWeights: previousWeights), bestDay: logs.min { abs(ProgressAnalyticsCalculator.value(for: $0, metric: .calories) - ($0.calorieGoalSnapshot > 0 ? $0.calorieGoalSnapshot : 0)) < abs(ProgressAnalyticsCalculator.value(for: $1, metric: .calories) - ($1.calorieGoalSnapshot > 0 ? $1.calorieGoalSnapshot : 0)) }, lowestDay: logs.min { ProgressAnalyticsCalculator.value(for: $0, metric: .calories) < ProgressAnalyticsCalculator.value(for: $1, metric: .calories) })
    }
}
