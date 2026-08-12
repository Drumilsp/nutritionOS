import Foundation

struct GetProgressSummaryUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let weightRepository: any WeightRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, weightRepository: any WeightRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.weightRepository = weightRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute(for range: ProgressTimeRange) async throws -> ProgressSummary {
        let dates = ProgressDateRange.dates(for: range, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        let weights = try await weightRepository.entries(from: dates.start, to: dates.end)
        let previous = ProgressDateRange.previousDates(for: range, now: dateProvider.now, calendar: calendar)
        let previousLogs = try await self.logs(for: previous)
        let previousWeights = try await weightRepository.entries(from: previous?.start, to: previous?.end)
        let cards = ProgressMetric.allCases.map { metric -> MetricSummaryCard in
            let current = metric == .weight ? ProgressAnalyticsCalculator.averageWeight(weights) : ProgressAnalyticsCalculator.average(logs, metric: metric)
            let averageGoal = logs.compactMap { ProgressAnalyticsCalculator.goal(for: $0, metric: metric) }.averageOrNil
            let adherence = metric == .weight || metric == .fibre ? nil : ProgressAnalyticsCalculator.adherence(logs: logs, metric: metric).hitRate
            return MetricSummaryCard(metric: metric, currentValue: current, goal: averageGoal, goalHitRate: adherence, trend: ProgressAnalyticsCalculator.trend(metric: metric, currentLogs: logs, previousLogs: previousLogs, currentWeights: weights, previousWeights: previousWeights))
        }
        let net = ProgressAnalyticsCalculator.netEnergyBalance(logs: logs)
        return ProgressSummary(cards: cards, weeklyNetEnergyBalance: net, estimatedFatLoss: ProgressAnalyticsCalculator.estimatedFatLoss(netEnergyBalance: net))
    }
    private func logs(for range: (start: Date?, end: Date)?) async throws -> [DailyLog] {
        guard let range else { return [] }
        return try await dailyLogRepository.logs(from: range.start ?? .distantPast, to: range.end)
    }
}

private extension Array where Element == Double {
    var averageOrNil: Double? { isEmpty ? nil : reduce(0, +) / Double(count) }
}
