import Foundation

struct GetConsistencyMetricsUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar

    init(dailyLogRepository: any DailyLogRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) {
        self.dailyLogRepository = dailyLogRepository
        self.dateProvider = dateProvider
        self.calendar = calendar
    }

    func execute(for range: ProgressTimeRange) async throws -> ConsistencyMetrics {
        let dates = ProgressDateRange.dates(for: range, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        let completedDays = Set(logs.filter(\.isCompleted).map { calendar.startOfDay(for: $0.date) })
        let loggedDays = logs.count
        let expected = max((calendar.dateComponents([.day], from: dates.start ?? dates.end, to: dates.end).day ?? 0) + 1, 1)
        return ConsistencyMetrics(
            currentStreak: streak(in: completedDays, ending: dates.end),
            longestStreak: longest(in: completedDays),
            loggedDays: loggedDays,
            missedDays: max(expected - loggedDays, 0),
            weeklyConsistency: Double(completedDays.count) / Double(expected)
        )
    }

    private func streak(in days: Set<Date>, ending end: Date) -> Int {
        var count = 0; var day = calendar.startOfDay(for: end)
        while days.contains(day) { count += 1; guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }; day = previous }
        return count
    }

    private func longest(in days: Set<Date>) -> Int {
        days.sorted().reduce((last: Date?.none, count: 0, best: 0)) { result, day in
            let consecutive = result.last.map { calendar.dateComponents([.day], from: $0, to: day).day == 1 } ?? false
            let count = consecutive ? result.count + 1 : 1
            return (day, count, max(result.best, count))
        }.best
    }
}
