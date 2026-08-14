//
//  UpdateGoalSettingsUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct UpdateGoalSettingsUseCase {

    // MARK: - Properties

    private let settingsRepository: any SettingsRepository
    private let validator: GoalSettingsValidator
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        settingsRepository: any SettingsRepository,
        validator: GoalSettingsValidator = GoalSettingsValidator(),
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.settingsRepository = settingsRepository
        self.validator = validator
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(_ goalSettings: GoalSettings) async throws -> GoalSettings {
        let updatedGoalSettings = GoalSettings(
            id: goalSettings.id,
            goalType: goalSettings.goalType,
            energyBalanceTarget: goalSettings.energyBalanceTarget,
            energyBalanceLowerBound: goalSettings.energyBalanceLowerBound,
            energyBalanceUpperBound: goalSettings.energyBalanceUpperBound,
            goalCalculationMode: goalSettings.goalCalculationMode,
            activityLevel: goalSettings.activityLevel,
            dailyProteinGoal: goalSettings.dailyProteinGoal,
            dailyCarbohydrateGoal: goalSettings.dailyCarbohydrateGoal,
            dailyFatGoal: goalSettings.dailyFatGoal,
            dailyWaterGoal: goalSettings.dailyWaterGoal,
            goalCalculationVersion: goalSettings.goalCalculationVersion,
            createdAt: goalSettings.createdAt,
            updatedAt: dateProvider.now
        )
        try validator.validate(updatedGoalSettings).throwIfInvalid()

        return try await settingsRepository.saveGoalSettings(updatedGoalSettings)
    }
}
