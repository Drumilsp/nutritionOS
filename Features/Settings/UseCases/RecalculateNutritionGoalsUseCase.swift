//
//  RecalculateNutritionGoalsUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct RecalculateNutritionGoalsUseCase {

    // MARK: - Properties

    private let settingsRepository: any SettingsRepository
    private let validator: GoalSettingsValidator
    private let dateProvider: any DateProvider
    private let calendar: Calendar

    // MARK: - Initialization

    init(
        settingsRepository: any SettingsRepository,
        validator: GoalSettingsValidator = GoalSettingsValidator(),
        dateProvider: any DateProvider = SystemDateProvider(),
        calendar: Calendar = .current
    ) {
        self.settingsRepository = settingsRepository
        self.validator = validator
        self.dateProvider = dateProvider
        self.calendar = calendar
    }

    // MARK: - Public Methods

    func execute(
        restingCalories: Double? = nil,
        activeCalories: Double? = nil
    ) async throws -> GoalSettings {
        let userProfile = try await settingsRepository.userProfile()
        let currentGoalSettings = try await settingsRepository.goalSettings()

        guard currentGoalSettings.goalCalculationMode == .automatic else {
            return currentGoalSettings
        }

        let targetCalories = maintenanceCalories(
            for: userProfile,
            goalSettings: currentGoalSettings,
            restingCalories: restingCalories,
            activeCalories: activeCalories
        ) + currentGoalSettings.energyBalanceTarget.calorieAdjustment
        let proteinGoal = proteinGoal(for: userProfile, goalType: currentGoalSettings.goalType)
        let fatGoal = max(userProfile.currentWeight * 0.8, 40)
        let remainingCalories = max(targetCalories - (proteinGoal * 4) - (fatGoal * 9), 0)
        let carbohydrateGoal = remainingCalories / 4
        let updatedGoalSettings = GoalSettings(
            id: currentGoalSettings.id,
            goalType: currentGoalSettings.goalType,
            energyBalanceTarget: currentGoalSettings.energyBalanceTarget,
            energyBalanceLowerBound: currentGoalSettings.energyBalanceLowerBound,
            energyBalanceUpperBound: currentGoalSettings.energyBalanceUpperBound,
            goalCalculationMode: currentGoalSettings.goalCalculationMode,
            activityLevel: currentGoalSettings.activityLevel,
            dailyProteinGoal: proteinGoal,
            dailyCarbohydrateGoal: carbohydrateGoal,
            dailyFatGoal: fatGoal,
            dailyWaterGoal: max(userProfile.currentWeight * 35, 2_000),
            goalCalculationVersion: currentGoalSettings.goalCalculationVersion + 1,
            createdAt: currentGoalSettings.createdAt,
            updatedAt: dateProvider.now
        )
        try validator.validate(updatedGoalSettings).throwIfInvalid()

        return try await settingsRepository.saveGoalSettings(updatedGoalSettings)
    }

    // MARK: - Private Methods

    private func maintenanceCalories(
        for userProfile: UserProfile,
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
        let age = max(calendar.dateComponents([.year], from: userProfile.dateOfBirth, to: dateProvider.now).year ?? 0, 0)
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

    private func proteinGoal(for userProfile: UserProfile, goalType: GoalType) -> Double {
        switch goalType {
        case .loseFat:
            return userProfile.currentWeight * 2
        case .maintainWeight:
            return userProfile.currentWeight * 1.6
        case .buildMuscle:
            return userProfile.currentWeight * 1.8
        }
    }
}
