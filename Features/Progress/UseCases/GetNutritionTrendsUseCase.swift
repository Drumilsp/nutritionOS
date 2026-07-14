import Foundation

struct GetNutritionTrendsUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let weightRepository: any WeightRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, weightRepository: any WeightRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.weightRepository = weightRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute(for range: ProgressTimeRange) async throws -> [ProgressTrend] {
        let current = ProgressDateRange.dates(for: range, now: dateProvider.now, calendar: calendar)
        let currentLogs = try await dailyLogRepository.logs(from: current.start ?? .distantPast, to: current.end)
        let currentWeights = try await weightRepository.entries(from: current.start, to: current.end)
        let previous = ProgressDateRange.previousDates(for: range, now: dateProvider.now, calendar: calendar)
        let previousLogs: [DailyLog]
        let previousWeights: [WeightEntry]
        if let previous {
            previousLogs = try await dailyLogRepository.logs(from: previous.start ?? .distantPast, to: previous.end)
            previousWeights = try await weightRepository.entries(from: previous.start, to: previous.end)
        } else {
            previousLogs = []
            previousWeights = []
        }
        return ProgressMetric.allCases.map { ProgressAnalyticsCalculator.trend(metric: $0, currentLogs: currentLogs, previousLogs: previousLogs, currentWeights: currentWeights, previousWeights: previousWeights) }
    }
}
