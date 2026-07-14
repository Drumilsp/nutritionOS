import Foundation

/// A generated, non-persisted read model for the Progress presentation layer.
struct ProgressSnapshot {
    let summary: ProgressSummary
    let weeklySummary: WeeklySummary
    let monthlySummary: MonthlySummary
    let trends: [ProgressTrend]
    let chartDatasets: [ProgressChartDataset]
    let consistencyScore: ConsistencyScore
    let todayImpact: TodayImpact
}
