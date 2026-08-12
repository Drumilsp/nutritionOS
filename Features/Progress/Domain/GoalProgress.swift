import Foundation

struct GoalProgress: Identifiable {
    let metric: ProgressMetric
    let currentValue: Double
    let goal: Double
    var remainingValue: Double { max(goal - currentValue, 0) }
    var completionPercentage: Double { goal > 0 ? min(currentValue / goal, 1) : 0 }
    var id: ProgressMetric { metric }
}
