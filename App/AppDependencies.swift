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
}
