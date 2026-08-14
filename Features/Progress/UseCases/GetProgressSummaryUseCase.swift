import Foundation

struct GetProgressSummaryUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let weightRepository: any WeightRepository
    private let settingsRepository: any SettingsRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar
    init(dailyLogRepository: any DailyLogRepository, weightRepository: any WeightRepository, settingsRepository: any SettingsRepository, dateProvider: any DateProvider = SystemDateProvider(), calendar: Calendar = .current) { self.dailyLogRepository = dailyLogRepository; self.weightRepository = weightRepository; self.settingsRepository = settingsRepository; self.dateProvider = dateProvider; self.calendar = calendar }
    func execute(for range: ProgressTimeRange) async throws -> ProgressSummary {
        let dates = ProgressDateRange.dates(for: range, now: dateProvider.now, calendar: calendar)
        let logs = try await dailyLogRepository.logs(from: dates.start ?? .distantPast, to: dates.end)
        let goalSettings = try await settingsRepository.goalSettings()
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
        let targetRange = energyBalanceTargetRange(from: goalSettings)
        return ProgressSummary(
            cards: cards,
            energyBalance: energyBalance(for: logs),
            historyDays: historyDays(from: dates.start, through: dates.end, logs: logs, targetRange: targetRange),
            hasEnergyBalanceTargetRange: targetRange != nil
        )
    }
    private func logs(for range: (start: Date?, end: Date)?) async throws -> [DailyLog] {
        guard let range else { return [] }
        return try await dailyLogRepository.logs(from: range.start ?? .distantPast, to: range.end)
    }

    private func energyBalance(for logs: [DailyLog]) -> EnergyBalanceAvailability {
        guard !logs.isEmpty else { return .tdeeNotConfigured }
        guard logs.allSatisfy({ $0.maintenanceCaloriesSnapshot > 0 }) else { return .tdeeNotConfigured }
        guard logs.allSatisfy({ $0.activeCalories != nil }) else { return .activeCaloriesUnavailable }
        let consumed = logs.reduce(0) { $0 + DailyLogCalculations.totals(for: $1).calories }
        let estimatedBurn = logs.reduce(0) { $0 + $1.maintenanceCaloriesSnapshot + ($1.activeCalories ?? 0) }
        let netEnergy = consumed - estimatedBurn
        return .available(consumedCalories: consumed, estimatedBurn: estimatedBurn, label: netEnergy <= 0 ? "Deficit" : "Surplus", amount: abs(netEnergy))
    }

    private func energyBalanceTargetRange(from settings: GoalSettings) -> ClosedRange<Double>? {
        guard let lowerBound = settings.energyBalanceLowerBound,
              let upperBound = settings.energyBalanceUpperBound else {
            return nil
        }
        return lowerBound...upperBound
    }

    private func historyDays(
        from startDate: Date?,
        through endDate: Date,
        logs: [DailyLog],
        targetRange: ClosedRange<Double>?
    ) -> [ProgressHistoryDay] {
        guard let startDate else { return [] }
        let logsByDate = Dictionary(uniqueKeysWithValues: logs.map { (calendar.startOfDay(for: $0.date), $0) })
        var date = calendar.startOfDay(for: startDate)
        let finalDate = calendar.startOfDay(for: endDate)
        var days: [ProgressHistoryDay] = []

        while date <= finalDate {
            let log = logsByDate[date]
            let balance = log.flatMap(energyBalance(for:))
            let status: ProgressHistoryDayStatus
            if let balance, let targetRange {
                status = targetRange.contains(balance) ? .onTarget : .offTarget
            } else {
                status = .neutral
            }
            days.append(ProgressHistoryDay(date: date, log: log, energyBalance: balance, status: status))
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }

        return days
    }

    private func energyBalance(for log: DailyLog) -> Double? {
        guard log.maintenanceCaloriesSnapshot > 0,
              let activeCalories = log.activeCalories else {
            return nil
        }
        return DailyLogCalculations.totals(for: log).calories - log.maintenanceCaloriesSnapshot - activeCalories
    }
}

private extension Array where Element == Double {
    var averageOrNil: Double? { isEmpty ? nil : reduce(0, +) / Double(count) }
}
