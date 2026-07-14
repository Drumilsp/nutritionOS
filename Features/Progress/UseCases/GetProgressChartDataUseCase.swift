import Foundation

struct GetProgressChartDataUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let weightRepository: any WeightRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, weightRepository: any WeightRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.weightRepository = weightRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute(for range: ProgressTimeRange) async throws -> [ProgressChartDataset] {
        let dates = ProgressDateRange.dates(for: range, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        let weights = try await weightRepository.entries(from: dates.start, to: dates.end)
        return ProgressAnalyticsCalculator.charts(logs: logs, weights: weights)
    }
}
