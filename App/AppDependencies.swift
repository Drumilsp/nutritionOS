//
//  AppDependencies.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Composition root for long-lived application dependencies.
@MainActor
struct AppDependencies {

    // MARK: - Properties

    /// Owns the app's persistence lifetime.
    let persistenceManager: PersistenceManager

    /// Provides food template persistence.
    let foodRepository: any FoodRepository

    /// Provides meal template persistence.
    let mealRepository: any MealRepository

    /// Provides daily log persistence.
    let dailyLogRepository: any DailyLogRepository

    /// Provides settings persistence.
    let settingsRepository: any SettingsRepository

    // MARK: - Initialization

    /// Creates application dependencies with production persistence.
    init() {
        self.init(persistenceConfiguration: .production)
    }

    /// Creates application dependencies for a selected persistence configuration.
    init(
        persistenceConfiguration: PersistenceConfiguration
    ) {
        let persistenceManager = PersistenceManager(
            configuration: persistenceConfiguration
        )

        self.persistenceManager = persistenceManager
        self.foodRepository = SwiftDataFoodRepository(
            persistenceManager: persistenceManager
        )
        self.mealRepository = SwiftDataMealRepository(
            persistenceManager: persistenceManager
        )
        self.dailyLogRepository = SwiftDataDailyLogRepository(
            persistenceManager: persistenceManager
        )
        self.settingsRepository = SwiftDataSettingsRepository(
            persistenceManager: persistenceManager
        )
    }

    // MARK: - Factory Methods

    /// Creates the Dashboard ViewModel with its approved use case dependency.
    func makeDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(
            getDashboardDataUseCase: GetDashboardDataUseCase(
                dailyLogRepository: dailyLogRepository,
                settingsRepository: settingsRepository
            )
        )
    }

    func makeFoodListViewModel() -> FoodListViewModel {
        FoodListViewModel(
            getFoodsUseCase: GetFoodsUseCase(foodRepository: foodRepository),
            searchFoodsUseCase: SearchFoodsUseCase(foodRepository: foodRepository),
            getFavoriteFoodsUseCase: GetFavoriteFoodsUseCase(foodRepository: foodRepository),
            foodRepository: foodRepository
        )
    }

    func makeFoodDetailViewModel() -> FoodDetailViewModel {
        FoodDetailViewModel(
            getFoodDetailUseCase: GetFoodDetailUseCase(foodRepository: foodRepository),
            favoriteFoodUseCase: FavoriteFoodUseCase(foodRepository: foodRepository),
            archiveFoodUseCase: ArchiveFoodUseCase(foodRepository: foodRepository),
            duplicateFoodUseCase: DuplicateFoodUseCase(foodRepository: foodRepository),
            deleteFoodUseCase: DeleteFoodUseCase(foodRepository: foodRepository)
        )
    }

    func makeFoodEditorViewModel(food: Food, isEditingExistingFood: Bool) -> FoodEditorViewModel {
        FoodEditorViewModel(
            food: food,
            isEditingExistingFood: isEditingExistingFood,
            createFoodUseCase: CreateFoodUseCase(foodRepository: foodRepository),
            updateFoodUseCase: UpdateFoodUseCase(foodRepository: foodRepository)
        )
    }

    func makeMealListViewModel() -> MealListViewModel {
        MealListViewModel(
            getMealsUseCase: GetMealsUseCase(mealRepository: mealRepository),
            searchMealsUseCase: SearchMealsUseCase(mealRepository: mealRepository),
            getFavoriteMealsUseCase: GetFavoriteMealsUseCase(mealRepository: mealRepository),
            getRecentlyUsedMealsUseCase: GetRecentlyUsedMealsUseCase(mealRepository: mealRepository)
        )
    }

    func makeMealDetailViewModel() -> MealDetailViewModel {
        MealDetailViewModel(
            getMealDetailUseCase: GetMealDetailUseCase(mealRepository: mealRepository),
            favoriteMealUseCase: FavoriteMealUseCase(mealRepository: mealRepository),
            archiveMealUseCase: ArchiveMealUseCase(mealRepository: mealRepository),
            duplicateMealUseCase: DuplicateMealUseCase(mealRepository: mealRepository),
            deleteMealUseCase: DeleteMealUseCase(mealRepository: mealRepository)
        )
    }

    func makeMealEditorViewModel(meal: Meal, isEditingExistingMeal: Bool) -> MealEditorViewModel {
        MealEditorViewModel(
            meal: meal,
            isEditingExistingMeal: isEditingExistingMeal,
            createMealUseCase: CreateMealUseCase(mealRepository: mealRepository),
            updateMealUseCase: UpdateMealUseCase(mealRepository: mealRepository)
        )
    }

    func makeDailyLogViewModel() -> DailyLogViewModel {
        DailyLogViewModel(
            createDailyLogIfNeededUseCase: CreateDailyLogIfNeededUseCase(dailyLogRepository: dailyLogRepository, settingsRepository: settingsRepository),
            suggestionsUseCase: GetSuggestionsUseCase(foodRepository: foodRepository, mealRepository: mealRepository)
        )
    }
}
