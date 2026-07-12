//
//  GetDashboardSummaryUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct GetDashboardSummaryUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(date: Date? = nil) async throws -> DashboardSummary {
        let dailyLog = try await dailyLogRepository.log(date: date ?? dateProvider.now)
        let nutritionProfiles = dailyLog.loggedFoods.map(\.nutritionProfileSnapshot)
            + dailyLog.loggedMeals.flatMap { $0.loggedFoods.map(\.nutritionProfileSnapshot) }

        return DashboardSummary(
            date: dailyLog.date,
            caloriesConsumed: total(.calories, in: nutritionProfiles),
            proteinConsumed: total(.protein, in: nutritionProfiles),
            fatConsumed: total(.fat, in: nutritionProfiles),
            fibreConsumed: total(.fibre, in: nutritionProfiles),
            waterIntake: dailyLog.waterIntake,
            calorieGoal: dailyLog.calorieGoalSnapshot,
            proteinGoal: dailyLog.proteinGoalSnapshot,
            fatGoal: dailyLog.fatGoalSnapshot,
            fibreGoal: dailyLog.fibreGoalSnapshot,
            maintenanceCalories: dailyLog.maintenanceCaloriesSnapshot,
            activeCalories: dailyLog.activeCalories,
            restingCalories: dailyLog.restingCalories
        )
    }

    // MARK: - Private Methods

    private func total(_ nutrientType: NutrientType, in nutritionProfiles: [NutritionProfile]) -> Double {
        nutritionProfiles.reduce(0) { $0 + $1.value(for: nutrientType) }
    }
}
