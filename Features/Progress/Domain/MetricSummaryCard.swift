import Foundation

struct MetricSummaryCard: Identifiable {
    let metric: ProgressMetric
    let currentValue: Double
    let goal: Double?
    let goalHitRate: Double?
    let trend: ProgressTrend?
    var id: ProgressMetric { metric }
}
