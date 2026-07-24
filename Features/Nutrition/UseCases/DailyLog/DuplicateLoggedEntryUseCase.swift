import Foundation

struct DuplicateLoggedEntryUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let uuidProvider: any UUIDProvider
    init(dailyLogRepository: any DailyLogRepository, uuidProvider: any UUIDProvider = SystemUUIDProvider()) { self.dailyLogRepository = dailyLogRepository; self.uuidProvider = uuidProvider }
    func execute(_ entry: TimelineEntry, date: Date, timestamp: Date = Date()) async throws -> DailyLog {
        switch entry {
        case .food(let food): return try await dailyLogRepository.addLoggedFood(LoggedFood(id: uuidProvider.makeUUID(), foodID: food.foodID, foodName: food.foodName, category: food.category, referenceQuantity: food.referenceQuantity, referenceUnit: food.referenceUnit, loggedQuantity: food.loggedQuantity, nutritionProfileSnapshot: food.nutritionProfileSnapshot, mealSlot: food.mealSlot, createdAt: timestamp, source: food.source, notes: food.notes), to: date)
        case .meal(let meal): return try await dailyLogRepository.addLoggedMeal(LoggedMeal(id: uuidProvider.makeUUID(), mealID: meal.mealID, mealName: meal.mealName, loggedFoods: meal.loggedFoods, mealSlot: meal.mealSlot, servingMultiplier: meal.servingMultiplier, createdAt: timestamp, source: meal.source, notes: meal.notes), to: date)
        case .water(let water): return try await dailyLogRepository.addWaterEntry(WaterEntry(id: uuidProvider.makeUUID(), amount: water.amount, timestamp: timestamp), to: date)
        }
    }
}
