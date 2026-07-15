import Foundation

/// Produces deterministic, local food and meal suggestions from remaining goals.
struct GetSuggestionsUseCase {
    struct Suggestions { let foods: [Food]; let meals: [Meal] }
    private let foodRepository: any FoodRepository
    private let mealRepository: any MealRepository
    init(foodRepository: any FoodRepository, mealRepository: any MealRepository) { self.foodRepository = foodRepository; self.mealRepository = mealRepository }
    func execute(for log: DailyLog) async throws -> Suggestions {
        let totals = DailyLogCalculations.totals(for: log)
        let foods = try await foodRepository.allFoods().filter { !$0.isArchived }.sorted { score($0.nutritionProfile, totals: totals, log: log) > score($1.nutritionProfile, totals: totals, log: log) }.prefix(3)
        let meals = try await mealRepository.allMeals().filter { !$0.isArchived }.sorted { score($0.nutritionProfile(), totals: totals, log: log) > score($1.nutritionProfile(), totals: totals, log: log) }.prefix(3)
        return Suggestions(foods: Array(foods), meals: Array(meals))
    }
    private func score(_ profile: NutritionProfile, totals: DailyTotals, log: DailyLog) -> Double {
        let proteinNeed = max(log.proteinGoalSnapshot - totals.protein, 0)
        let carbohydrateNeed = max(log.carbohydrateGoalSnapshot - totals.carbohydrates, 0)
        let fatNeed = max(log.fatGoalSnapshot - totals.fat, 0)
        return (profile.value(for: .protein) * proteinNeed) + (profile.value(for: .carbohydrates) * carbohydrateNeed) + (profile.value(for: .fat) * fatNeed)
    }
}
