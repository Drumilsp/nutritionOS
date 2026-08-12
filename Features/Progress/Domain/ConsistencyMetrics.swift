import Foundation

struct ConsistencyMetrics {
    let currentStreak: Int
    let longestStreak: Int
    let loggedDays: Int
    let missedDays: Int
    let weeklyConsistency: Double
}
