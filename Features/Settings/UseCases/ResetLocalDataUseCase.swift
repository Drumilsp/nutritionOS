import Foundation

struct ResetLocalDataUseCase {
    private let foodRepository: any FoodRepository
    private let mealRepository: any MealRepository
    private let dailyLogRepository: any DailyLogRepository
    private let weightRepository: any WeightRepository
    private let settingsRepository: any SettingsRepository

    init(foodRepository: any FoodRepository, mealRepository: any MealRepository, dailyLogRepository: any DailyLogRepository, weightRepository: any WeightRepository, settingsRepository: any SettingsRepository) {
        self.foodRepository = foodRepository; self.mealRepository = mealRepository; self.dailyLogRepository = dailyLogRepository; self.weightRepository = weightRepository; self.settingsRepository = settingsRepository
    }

    func execute() async throws {
        try await dailyLogRepository.deleteAllLogs()
        try await mealRepository.deleteAllMeals()
        try await foodRepository.deleteAllFoods()
        try await weightRepository.deleteAllEntries()
        try await settingsRepository.reset()
    }
}
