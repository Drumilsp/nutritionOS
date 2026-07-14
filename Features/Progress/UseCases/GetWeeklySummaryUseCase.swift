import Foundation

struct GetWeeklySummaryUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let weightRepository: any WeightRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, weightRepository: any WeightRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.weightRepository = weightRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute() async throws -> WeeklySummary {
        let dates = ProgressDateRange.dates(for: .sevenDays, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        let weights = try await weightRepository.entries(from: dates.start, to: dates.end)
        let net = ProgressAnalyticsCalculator.netEnergyBalance(logs: logs)
        return WeeklySummary(averageCalories: ProgressAnalyticsCalculator.average(logs, metric: .calories), averageProtein: ProgressAnalyticsCalculator.average(logs, metric: .protein), averageCarbohydrates: ProgressAnalyticsCalculator.average(logs, metric: .carbohydrates), averageFat: ProgressAnalyticsCalculator.average(logs, metric: .fat), averageWater: ProgressAnalyticsCalculator.average(logs, metric: .water), weightChange: ProgressAnalyticsCalculator.weightChange(weights), netEnergyBalance: net, estimatedFatLoss: ProgressAnalyticsCalculator.estimatedFatLoss(netEnergyBalance: net))
    }
}
