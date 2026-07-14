import Foundation

struct GoalAdherence {
    let metric: ProgressMetric
    let hitDays: Int
    let loggedDays: Int
    var hitRate: Double { loggedDays == 0 ? 0 : Double(hitDays) / Double(loggedDays) }
}
