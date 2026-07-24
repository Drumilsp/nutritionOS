import Foundation

/// Produces deterministic, local Today suggestions in UI-ready groups.
struct GetSuggestionsUseCase {

    struct Suggestions {
        let recentFoods: [Food]
        let frequentFoods: [Food]
        let favoriteFoods: [Food]
        let recentMeals: [Meal]
        let favoriteMeals: [Meal]

        /// Compatibility list for existing consumers that have not adopted groups yet.
        var foods: [Food] {
            unique(recentFoods + frequentFoods + favoriteFoods)
        }

        /// Compatibility list for existing consumers that have not adopted groups yet.
        var meals: [Meal] {
            unique(recentMeals + favoriteMeals)
        }

        private func unique<T: Identifiable>(_ items: [T]) -> [T] where T.ID == UUID {
            var identifiers = Set<UUID>()
            return items.filter { identifiers.insert($0.id).inserted }
        }
    }

    // MARK: - Properties

    private let foodRepository: any FoodRepository
    private let mealRepository: any MealRepository
    private let dailyLogRepository: any DailyLogRepository
    private let groupLimit: Int

    // MARK: - Initialization

    init(
        foodRepository: any FoodRepository,
        mealRepository: any MealRepository,
        dailyLogRepository: any DailyLogRepository,
        groupLimit: Int = 8
    ) {
        self.foodRepository = foodRepository
        self.mealRepository = mealRepository
        self.dailyLogRepository = dailyLogRepository
        self.groupLimit = groupLimit
    }

    // MARK: - Public Methods

    func execute(for _: DailyLog) async throws -> Suggestions {
        async let recentFoods = foodRepository.recentlyUsedFoods(limit: groupLimit)
        async let favoriteFoods = foodRepository.favoriteFoods()
        async let recentMeals = mealRepository.recentlyUsedMeals(limit: groupLimit)
        async let favoriteMeals = mealRepository.favoriteMeals()
        async let logs = dailyLogRepository.logs(from: .distantPast, to: .distantFuture)

        let foodUsageCounts = frequencyByFoodID(in: try await logs)
        let allFoods = try await foodRepository.allFoods()
        let frequentFoods = allFoods
            .filter { !$0.isArchived && (foodUsageCounts[$0.id] ?? 0) > 0 }
            .sorted { left, right in
                let leftCount = foodUsageCounts[left.id] ?? 0
                let rightCount = foodUsageCounts[right.id] ?? 0
                if leftCount != rightCount { return leftCount > rightCount }
                return left.name.localizedCaseInsensitiveCompare(right.name) == .orderedAscending
            }

        return Suggestions(
            recentFoods: try await recentFoods.filter { !$0.isArchived },
            frequentFoods: Array(frequentFoods.prefix(groupLimit)),
            favoriteFoods: try await favoriteFoods.filter { !$0.isArchived }.prefix(groupLimit).map { $0 },
            recentMeals: try await recentMeals.filter { !$0.isArchived },
            favoriteMeals: try await favoriteMeals.filter { !$0.isArchived }.prefix(groupLimit).map { $0 }
        )
    }

    // MARK: - Private Methods

    private func frequencyByFoodID(in logs: [DailyLog]) -> [UUID: Int] {
        let loggedFoods = logs.flatMap(\.loggedFoods) + logs.flatMap { $0.loggedMeals.flatMap(\.loggedFoods) }
        return loggedFoods.reduce(into: [:]) { counts, food in
            guard let foodID = food.foodID else { return }
            counts[foodID, default: 0] += 1
        }
    }
}
