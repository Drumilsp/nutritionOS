//
//  GetDashboardDataUseCase.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import Foundation

struct GetDashboardDataUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let settingsRepository: any SettingsRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        settingsRepository: any SettingsRepository,
        dateProvider: any DateProvider = SystemDateProvider(),
        calendar: Calendar = .current
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.settingsRepository = settingsRepository
        self.dateProvider = dateProvider
        self.calendar = calendar
    }

    // MARK: - Public Methods

    func execute() async throws -> DashboardData {
        let userProfile = try await settingsRepository.userProfile()
        let goalSettings = try await settingsRepository.goalSettings()
        let dailyLog = try await todaysLog(
            userProfile: userProfile,
            goalSettings: goalSettings
        )
        let nutritionProfiles = dailyLog.loggedFoods.map(\.nutritionProfileSnapshot)
            + dailyLog.loggedMeals.flatMap { $0.loggedFoods.map(\.nutritionProfileSnapshot) }
        let foodCalories = total(.calories, in: nutritionProfiles)
        let protein = macroProgress(
            current: total(.protein, in: nutritionProfiles),
            goal: resolvedGoal(dailyLog.proteinGoalSnapshot, fallback: goalSettings.dailyProteinGoal)
        )
        let carbohydrates = macroProgress(
            current: total(.carbohydrates, in: nutritionProfiles),
            goal: goalSettings.dailyCarbohydrateGoal
        )
        let fat = macroProgress(
            current: total(.fat, in: nutritionProfiles),
            goal: resolvedGoal(dailyLog.fatGoalSnapshot, fallback: goalSettings.dailyFatGoal)
        )
        let maintenanceCalories = resolvedMaintenanceCalories(
            dailyLog: dailyLog,
            userProfile: userProfile,
            goalSettings: goalSettings
        )
        let targetCalories = resolvedTargetCalories(
            dailyLog: dailyLog,
            maintenanceCalories: maintenanceCalories,
            goalSettings: goalSettings
        )

        return DashboardData(
            greeting: greeting(for: userProfile),
            currentDate: dailyLog.date,
            energySummary: EnergySummary(
                targetCalories: targetCalories,
                foodCalories: foodCalories,
                maintenanceCalories: maintenanceCalories,
                remainingCalories: targetCalories - foodCalories,
                restingCalories: dailyLog.restingCalories ?? 0,
                activeCalories: dailyLog.activeCalories ?? 0,
                caloriesBurned: (dailyLog.restingCalories ?? 0) + (dailyLog.activeCalories ?? 0),
                energyBalanceTarget: goalSettings.energyBalanceTarget
            ),
            macroSummary: MacroSummary(
                protein: protein,
                carbohydrates: carbohydrates,
                fat: fat
            ),
            waterSummary: WaterSummary(
                current: dailyLog.waterIntake,
                goal: goalSettings.dailyWaterGoal,
                remaining: max(goalSettings.dailyWaterGoal - dailyLog.waterIntake, 0),
                quickAddAmounts: [100, 250, 500, 750]
            ),
            mealSummary: mealSummary(for: dailyLog),
            quickActions: quickActions(),
            goalReminder: goalReminder(protein: protein),
            lastUpdated: dateProvider.now
        )
    }

    // MARK: - Private Methods

    private func todaysLog(
        userProfile: UserProfile,
        goalSettings: GoalSettings
    ) async throws -> DailyLog {
        do {
            return try await dailyLogRepository.log(date: dateProvider.now)
        } catch RepositoryError.notFound {
            return try await dailyLogRepository.save(
                DailyLog(
                    date: dateProvider.now,
                    calorieGoalSnapshot: targetCalories(
                        userProfile: userProfile,
                        goalSettings: goalSettings
                    ),
                    proteinGoalSnapshot: goalSettings.dailyProteinGoal,
                    fatGoalSnapshot: goalSettings.dailyFatGoal,
                    fibreGoalSnapshot: 0,
                    maintenanceCaloriesSnapshot: maintenanceCalories(
                        userProfile: userProfile,
                        goalSettings: goalSettings,
                        restingCalories: nil,
                        activeCalories: nil
                    )
                )
            )
        }
    }

    private func total(_ nutrientType: NutrientType, in nutritionProfiles: [NutritionProfile]) -> Double {
        nutritionProfiles.reduce(0) { $0 + $1.value(for: nutrientType) }
    }

    private func macroProgress(current: Double, goal: Double) -> MacroProgress {
        MacroProgress(
            current: current,
            goal: goal,
            remaining: max(goal - current, 0)
        )
    }

    private func resolvedGoal(_ snapshot: Double, fallback: Double) -> Double {
        snapshot > 0 ? snapshot : fallback
    }

    private func resolvedMaintenanceCalories(
        dailyLog: DailyLog,
        userProfile: UserProfile,
        goalSettings: GoalSettings
    ) -> Double {
        if dailyLog.maintenanceCaloriesSnapshot > 0 {
            return dailyLog.maintenanceCaloriesSnapshot
        }

        return maintenanceCalories(
            userProfile: userProfile,
            goalSettings: goalSettings,
            restingCalories: dailyLog.restingCalories,
            activeCalories: dailyLog.activeCalories
        )
    }

    private func resolvedTargetCalories(
        dailyLog: DailyLog,
        maintenanceCalories: Double,
        goalSettings: GoalSettings
    ) -> Double {
        if dailyLog.calorieGoalSnapshot > 0 {
            return dailyLog.calorieGoalSnapshot
        }

        return maintenanceCalories + goalSettings.energyBalanceTarget.calorieAdjustment
    }

    private func targetCalories(
        userProfile: UserProfile,
        goalSettings: GoalSettings
    ) -> Double {
        maintenanceCalories(
            userProfile: userProfile,
            goalSettings: goalSettings,
            restingCalories: nil,
            activeCalories: nil
        ) + goalSettings.energyBalanceTarget.calorieAdjustment
    }

    private func maintenanceCalories(
        userProfile: UserProfile,
        goalSettings: GoalSettings,
        restingCalories: Double?,
        activeCalories: Double?
    ) -> Double {
        if let restingCalories, let activeCalories {
            return max(restingCalories + activeCalories, 0)
        }

        return basalMetabolicRate(for: userProfile) * goalSettings.activityLevel.multiplier
    }

    private func basalMetabolicRate(for userProfile: UserProfile) -> Double {
        let age = max(
            calendar.dateComponents([.year], from: userProfile.dateOfBirth, to: dateProvider.now).year ?? 0,
            0
        )
        let base = (10 * userProfile.currentWeight) + (6.25 * userProfile.height) - (5 * Double(age))

        switch userProfile.biologicalSex {
        case .female:
            return base - 161
        case .male:
            return base + 5
        case .unspecified:
            return base - 78
        }
    }

    private func mealSummary(for dailyLog: DailyLog) -> MealSummary {
        MealSummary(
            breakfast: mealSummaryItem(for: .breakfast, dailyLog: dailyLog),
            lunch: mealSummaryItem(for: .lunch, dailyLog: dailyLog),
            dinner: mealSummaryItem(for: .dinner, dailyLog: dailyLog),
            snack: mealSummaryItem(for: .snack, dailyLog: dailyLog)
        )
    }

    private func mealSummaryItem(for mealSlot: MealSlot, dailyLog: DailyLog) -> MealSummaryItem {
        let directCalories = dailyLog.loggedFoods
            .filter { $0.mealSlot == mealSlot }
            .reduce(0) { $0 + $1.nutritionProfileSnapshot.value(for: .calories) }
        let mealCalories = dailyLog.loggedMeals
            .filter { $0.mealSlot == mealSlot }
            .flatMap(\.loggedFoods)
            .reduce(0) { $0 + $1.nutritionProfileSnapshot.value(for: .calories) }
        let calories = directCalories + mealCalories

        return MealSummaryItem(
            id: mealSlot,
            title: title(for: mealSlot),
            completionState: calories > 0 ? .logged : .notLogged,
            calories: calories > 0 ? calories : nil
        )
    }

    private func title(for mealSlot: MealSlot) -> String {
        switch mealSlot {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .snack:
            return "Snack"
        }
    }

    private func quickActions() -> [QuickAction] {
        [
            QuickAction(id: .addFood, title: "Add Food", systemImage: "plus.circle.fill"),
            QuickAction(id: .addMeal, title: "Add Meal", systemImage: "fork.knife.circle.fill"),
            QuickAction(id: .addWater, title: "Add Water", systemImage: "drop.circle.fill")
        ]
    }

    private func greeting(for userProfile: UserProfile) -> String {
        let hour = calendar.component(.hour, from: dateProvider.now)
        let greeting: String

        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<22:
            greeting = "Good Evening"
        default:
            greeting = "Good Night"
        }

        guard let name = userProfile.name, name.isEmpty == false else {
            return greeting
        }

        return "\(greeting), \(name)"
    }

    private func goalReminder(protein: MacroProgress) -> String? {
        guard protein.remaining > 0, protein.remaining <= 20 else {
            return nil
        }

        return "Only \(Int(protein.remaining.rounded())) g protein remaining."
    }
}
