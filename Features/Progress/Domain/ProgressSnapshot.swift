import Foundation

/// A generated, non-persisted read model for the Progress presentation layer.
struct ProgressSnapshot {
    let todaySummary: DashboardSummary?
    let summary: ProgressSummary
    let trends: [ProgressTrend]
    let chartDatasets: [ProgressChartDataset]
    let consistencyScore: ConsistencyScore
    let todayImpact: TodayImpact
    let goalProgress: [GoalProgress]
    let consistencyMetrics: ConsistencyMetrics
}
