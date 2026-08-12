import Foundation

enum DailyLogCalculations {
    static func totals(for log: DailyLog) -> DailyTotals {
        let profiles = log.loggedFoods.map(\.nutritionProfileSnapshot) + log.loggedMeals.flatMap { $0.loggedFoods.map(\.nutritionProfileSnapshot) }
        func total(_ nutrient: NutrientType) -> Double { profiles.reduce(0) { $0 + $1.value(for: nutrient) } }
        return DailyTotals(calories: total(.calories), protein: total(.protein), carbohydrates: total(.carbohydrates), fat: total(.fat), fibre: total(.fibre), water: log.totalWater)
    }
    static func timeline(for log: DailyLog) -> [TimelineEntry] { (log.loggedFoods.map(TimelineEntry.food) + log.loggedMeals.map(TimelineEntry.meal) + log.waterEntries.map(TimelineEntry.water)).sorted { $0.timestamp > $1.timestamp } }
}
