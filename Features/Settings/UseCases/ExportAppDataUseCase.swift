import Foundation

struct ExportAppDataUseCase {
    private let foodRepository: any FoodRepository
    private let mealRepository: any MealRepository
    private let dailyLogRepository: any DailyLogRepository
    private let weightRepository: any WeightRepository
    private let settingsRepository: any SettingsRepository

    init(foodRepository: any FoodRepository, mealRepository: any MealRepository, dailyLogRepository: any DailyLogRepository, weightRepository: any WeightRepository, settingsRepository: any SettingsRepository) {
        self.foodRepository = foodRepository; self.mealRepository = mealRepository; self.dailyLogRepository = dailyLogRepository; self.weightRepository = weightRepository; self.settingsRepository = settingsRepository
    }

    func execute() async throws -> String {
        let foods = try await foodRepository.allFoods()
        let meals = try await mealRepository.allMeals()
        let logs = try await dailyLogRepository.logs(from: .distantPast, to: .distantFuture)
        let weights = try await weightRepository.entries(from: nil, to: nil)
        let goals = try await settingsRepository.goalSettings()
        var lines = [
            "Nutrition OS Export", "Foods: \(foods.count)", "Meals: \(meals.count)", "Logs: \(logs.count)", "Weight Entries: \(weights.count)",
            "Protein Goal: \(goals.dailyProteinGoal)", "Carbohydrate Goal: \(goals.dailyCarbohydrateGoal)", "Fat Goal: \(goals.dailyFatGoal)", "Water Goal: \(goals.dailyWaterGoal)"
        ]
        lines += foods.map { "Food,\($0.name)" }
        lines += meals.map { "Meal,\($0.name)" }
        let formatter = ISO8601DateFormatter()
        lines += logs.map { "Log,\(formatter.string(from: $0.date))" }
        lines += weights.map { "Weight,\(formatter.string(from: $0.recordedAt)),\($0.weight)" }
        return lines.joined(separator: "\n")
    }
}
