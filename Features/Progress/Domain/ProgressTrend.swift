import Foundation

enum TrendDirection { case up, down, noChange }

struct ProgressTrend {
    let metric: ProgressMetric
    let direction: TrendDirection
    let change: Double
}
