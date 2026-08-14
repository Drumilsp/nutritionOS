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

    /// Provides recorded body-weight persistence.
    let weightRepository: any WeightRepository

    /// Provides optional Apple Health integration.
    let healthRepository: any HealthRepository

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
        self.weightRepository = SwiftDataWeightRepository(
            persistenceManager: persistenceManager
        )
        self.healthRepository = HealthKitRepository(persistenceManager: persistenceManager)
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

    func makeProgressViewModel() -> ProgressViewModel {
        ProgressViewModel(
            getProgressSummaryUseCase: GetProgressSummaryUseCase(dailyLogRepository: dailyLogRepository, weightRepository: weightRepository, settingsRepository: settingsRepository),
            getNutritionTrendsUseCase: GetNutritionTrendsUseCase(dailyLogRepository: dailyLogRepository, weightRepository: weightRepository),
            getConsistencyScoreUseCase: GetConsistencyScoreUseCase(dailyLogRepository: dailyLogRepository),
            getTodayImpactUseCase: GetTodayImpactUseCase(dailyLogRepository: dailyLogRepository),
            getProgressChartDataUseCase: GetProgressChartDataUseCase(dailyLogRepository: dailyLogRepository, weightRepository: weightRepository),
            getGoalProgressUseCase: GetGoalProgressUseCase(dailyLogRepository: dailyLogRepository, settingsRepository: settingsRepository),
            getConsistencyMetricsUseCase: GetConsistencyMetricsUseCase(dailyLogRepository: dailyLogRepository),
            getDashboardSummaryUseCase: GetDashboardSummaryUseCase(dailyLogRepository: dailyLogRepository)
        )
    }

    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel(getHistoryUseCase: GetHistoryUseCase(dailyLogRepository: dailyLogRepository), searchHistoryUseCase: SearchHistoryUseCase(dailyLogRepository: dailyLogRepository))
    }

    func makeWeightHistoryViewModel() -> WeightHistoryViewModel {
        WeightHistoryViewModel(getWeightHistoryUseCase: GetWeightHistoryUseCase(weightRepository: weightRepository))
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(
            getSettingsSummaryUseCase: GetSettingsSummaryUseCase(settingsRepository: settingsRepository),
            getGoalSettingsUseCase: GetGoalSettingsUseCase(settingsRepository: settingsRepository),
            updateGoalSettingsUseCase: UpdateGoalSettingsUseCase(settingsRepository: settingsRepository),
            updateUnitSettingsUseCase: UpdateUnitSettingsUseCase(settingsRepository: settingsRepository),
            updateDisplayPreferencesUseCase: UpdateDisplayPreferencesUseCase(settingsRepository: settingsRepository),
            updateUserProfileUseCase: UpdateUserProfileUseCase(settingsRepository: settingsRepository),
            exportAppDataUseCase: ExportAppDataUseCase(foodRepository: foodRepository, mealRepository: mealRepository, dailyLogRepository: dailyLogRepository, weightRepository: weightRepository, settingsRepository: settingsRepository),
            importLibraryJSONUseCase: ImportLibraryJSONUseCase(foodRepository: foodRepository, mealRepository: mealRepository),
            resetLocalDataUseCase: ResetLocalDataUseCase(foodRepository: foodRepository, mealRepository: mealRepository, dailyLogRepository: dailyLogRepository, weightRepository: weightRepository, settingsRepository: settingsRepository),
            getAppInfoUseCase: GetAppInfoUseCase()
        )
    }

    func makeFoodViewModel() -> FoodViewModel {
        FoodViewModel(
            getFoodsUseCase: GetFoodsUseCase(foodRepository: foodRepository),
            searchFoodsUseCase: SearchFoodsUseCase(foodRepository: foodRepository),
            getFavoriteFoodsUseCase: GetFavoriteFoodsUseCase(foodRepository: foodRepository),
            getRecentlyUsedFoodsUseCase: GetRecentlyUsedFoodsUseCase(foodRepository: foodRepository),
            toggleFavoriteFoodUseCase: ToggleFavoriteFoodUseCase(foodRepository: foodRepository),
            archiveFoodUseCase: ArchiveFoodUseCase(foodRepository: foodRepository),
            restoreFoodUseCase: RestoreFoodUseCase(foodRepository: foodRepository),
            deleteFoodUseCase: DeleteFoodUseCase(foodRepository: foodRepository),
            duplicateFoodUseCase: DuplicateFoodUseCase(foodRepository: foodRepository)
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
            getRecentlyUsedMealsUseCase: GetRecentlyUsedMealsUseCase(mealRepository: mealRepository),
            toggleFavoriteMealUseCase: ToggleFavoriteMealUseCase(mealRepository: mealRepository),
            archiveMealUseCase: ArchiveMealUseCase(mealRepository: mealRepository),
            restoreMealUseCase: RestoreMealUseCase(mealRepository: mealRepository),
            deleteMealUseCase: DeleteMealUseCase(mealRepository: mealRepository),
            duplicateMealUseCase: DuplicateMealUseCase(mealRepository: mealRepository)
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
            updateMealUseCase: UpdateMealUseCase(mealRepository: mealRepository),
            getFoodsUseCase: GetFoodsUseCase(foodRepository: foodRepository),
            searchFoodsUseCase: SearchFoodsUseCase(foodRepository: foodRepository),
            validator: MealValidator()
        )
    }

    func makeDailyLogViewModel() -> DailyLogViewModel {
        DailyLogViewModel(
            createDailyLogIfNeededUseCase: CreateDailyLogIfNeededUseCase(dailyLogRepository: dailyLogRepository, settingsRepository: settingsRepository),
            suggestionsUseCase: GetSuggestionsUseCase(
                foodRepository: foodRepository,
                mealRepository: mealRepository,
                dailyLogRepository: dailyLogRepository
            )
        )
    }

    func makeLogFoodViewModel() -> LogFoodViewModel {
        LogFoodViewModel(
            searchFoodsUseCase: SearchFoodsUseCase(foodRepository: foodRepository),
            logFoodUseCase: LogFoodUseCase(
                foodRepository: foodRepository,
                dailyLogRepository: dailyLogRepository
            )
        )
    }

    func makeLogMealViewModel() -> LogMealViewModel {
        LogMealViewModel(
            searchMealsUseCase: SearchMealsUseCase(mealRepository: mealRepository),
            logMealUseCase: LogMealUseCase(
                mealRepository: mealRepository,
                dailyLogRepository: dailyLogRepository
            )
        )
    }

    func makeLogWaterViewModel() -> LogWaterViewModel {
        LogWaterViewModel(logWaterUseCase: LogWaterUseCase(dailyLogRepository: dailyLogRepository))
    }

    func makeLoggedEntryViewModel(entry: TimelineEntry) -> LoggedEntryViewModel {
        LoggedEntryViewModel(entry: entry, deleteLoggedEntryUseCase: DeleteLoggedEntryUseCase(dailyLogRepository: dailyLogRepository), duplicateLoggedEntryUseCase: DuplicateLoggedEntryUseCase(dailyLogRepository: dailyLogRepository), restoreLoggedEntryUseCase: RestoreLoggedEntryUseCase(dailyLogRepository: dailyLogRepository), updateLoggedFoodUseCase: UpdateLoggedFoodUseCase(dailyLogRepository: dailyLogRepository), updateLoggedMealUseCase: UpdateLoggedMealUseCase(dailyLogRepository: dailyLogRepository), updateWaterEntryUseCase: UpdateWaterEntryUseCase(dailyLogRepository: dailyLogRepository))
    }

    func makeHealthSettingsViewModel() -> HealthSettingsViewModel {
        HealthSettingsViewModel(
            requestPermissionsUseCase: RequestHealthPermissionsUseCase(healthRepository: healthRepository),
            getConnectionStatusUseCase: GetHealthConnectionStatusUseCase(healthRepository: healthRepository),
            syncHealthDataUseCase: SyncHealthDataUseCase(healthRepository: healthRepository, weightRepository: weightRepository, dailyLogRepository: dailyLogRepository),
            disconnectHealthUseCase: DisconnectHealthUseCase(healthRepository: healthRepository)
        )
    }

    func makeHealthSyncViewModel() -> HealthSyncViewModel {
        HealthSyncViewModel(syncHealthDataUseCase: SyncHealthDataUseCase(healthRepository: healthRepository, weightRepository: weightRepository, dailyLogRepository: dailyLogRepository))
    }
}
