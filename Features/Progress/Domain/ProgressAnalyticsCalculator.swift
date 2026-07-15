import Foundation

/// Pure calculations used by Progress use cases; results are never persisted.
enum ProgressAnalyticsCalculator {
    static let caloriesPerKilogramOfFat = 7_700.0

    static func average(_ logs: [DailyLog], metric: ProgressMetric) -> Double {
        guard !logs.isEmpty else { return 0 }
        return logs.reduce(0) { $0 + value(for: $1, metric: metric) } / Double(logs.count)
    }

    static func value(for log: DailyLog, metric: ProgressMetric) -> Double {
        let totals = DailyLogCalculations.totals(for: log)
        switch metric {
        case .calories: return totals.calories
        case .protein: return totals.protein
        case .carbohydrates: return totals.carbohydrates
        case .fat: return totals.fat
        case .water: return totals.water
        case .weight: return 0
        }
    }

    static func goal(for log: DailyLog, metric: ProgressMetric) -> Double? {
        switch metric {
        case .calories: return log.calorieGoalSnapshot > 0 ? log.calorieGoalSnapshot : nil
        case .protein: return log.proteinGoalSnapshot > 0 ? log.proteinGoalSnapshot : nil
        case .carbohydrates: return log.carbohydrateGoalSnapshot > 0 ? log.carbohydrateGoalSnapshot : nil
        case .fat: return log.fatGoalSnapshot > 0 ? log.fatGoalSnapshot : nil
        case .water: return log.waterGoalSnapshot > 0 ? log.waterGoalSnapshot : nil
        case .weight: return nil
        }
    }

    static func adherence(logs: [DailyLog], metric: ProgressMetric) -> GoalAdherence {
        let eligible = logs.filter { goal(for: $0, metric: metric) != nil }
        let hitDays = eligible.filter { log in
            guard let goal = goal(for: log, metric: metric) else { return false }
            let current = value(for: log, metric: metric)
            return metric == .calories ? current <= goal : current >= goal
        }.count
        return GoalAdherence(metric: metric, hitDays: hitDays, loggedDays: eligible.count)
    }

    static func trend(metric: ProgressMetric, currentLogs: [DailyLog], previousLogs: [DailyLog], currentWeights: [WeightEntry] = [], previousWeights: [WeightEntry] = []) -> ProgressTrend {
        let current: Double
        let previous: Double
        if metric == .weight {
            current = currentWeights.map(\.weight).average
            previous = previousWeights.map(\.weight).average
        } else {
            current = average(currentLogs, metric: metric)
            previous = average(previousLogs, metric: metric)
        }
        let change = current - previous
        let direction: TrendDirection = abs(change) < 0.001 ? .noChange : (change > 0 ? .up : .down)
        return ProgressTrend(metric: metric, direction: direction, change: change)
    }

    static func netEnergyBalance(logs: [DailyLog]) -> Double {
        logs.reduce(0) { total, log in
            let caloriesBurned = (log.restingCalories ?? 0) + (log.activeCalories ?? 0)
            let burned = caloriesBurned > 0 ? caloriesBurned : log.maintenanceCaloriesSnapshot
            return total + value(for: log, metric: .calories) - burned
        }
    }

    static func estimatedFatLoss(netEnergyBalance: Double) -> Double { -netEnergyBalance / caloriesPerKilogramOfFat }

    static func weightChange(_ entries: [WeightEntry]) -> Double? {
        guard let first = entries.first, let last = entries.last else { return nil }
        return last.weight - first.weight
    }

    static func averageWeight(_ entries: [WeightEntry]) -> Double {
        entries.map(\.weight).average
    }

    static func weightHistoryTrend(_ entries: [WeightEntry]) -> ProgressTrend? {
        guard let change = weightChange(entries) else { return nil }
        let direction: TrendDirection = abs(change) < 0.001 ? .noChange : (change > 0 ? .up : .down)
        return ProgressTrend(metric: .weight, direction: direction, change: change)
    }

    static func charts(logs: [DailyLog], weights: [WeightEntry]) -> [ProgressChartDataset] {
        let nutrition = ProgressMetric.allCases.filter { $0 != .weight }.map { metric in
            ProgressChartDataset(metric: metric, points: logs.sorted { $0.date < $1.date }.map { ProgressChartPoint(date: $0.date, value: value(for: $0, metric: metric)) })
        }
        return nutrition + [ProgressChartDataset(metric: .weight, points: weights.map { ProgressChartPoint(date: $0.recordedAt, value: $0.weight) })]
    }
}

private extension Array where Element == Double {
    var average: Double { isEmpty ? 0 : reduce(0, +) / Double(count) }
}
