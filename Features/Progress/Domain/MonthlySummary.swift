import Foundation

struct MonthlySummary {
    let averageCalories: Double
    let averageProtein: Double
    let averageCarbohydrates: Double
    let averageFat: Double
    let averageWater: Double
    let goalAdherence: [GoalAdherence]
    let weightTrend: ProgressTrend?
    let bestDay: DailyLog?
    let lowestDay: DailyLog?
}
