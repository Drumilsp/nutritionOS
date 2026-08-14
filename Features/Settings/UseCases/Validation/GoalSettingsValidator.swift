//
//  GoalSettingsValidator.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Validates nutrition goal configuration.
struct GoalSettingsValidator {

    // MARK: - Public Methods

    func validate(_ goalSettings: GoalSettings) -> ValidationResult {
        var errors: [ValidationError] = []

        if containsInvalidGoalValue([
            goalSettings.dailyProteinGoal,
            goalSettings.dailyCarbohydrateGoal,
            goalSettings.dailyFatGoal,
            goalSettings.dailyWaterGoal
        ]) {
            errors.append(.invalidGoal)
        }

        if goalSettings.goalCalculationVersion <= 0 {
            errors.append(.invalidGoal)
        }

        let lowerBound = goalSettings.energyBalanceLowerBound
        let upperBound = goalSettings.energyBalanceUpperBound
        if (lowerBound == nil) != (upperBound == nil)
            || lowerBound.map({ !$0.isFinite }) == true
            || upperBound.map({ !$0.isFinite }) == true
            || (lowerBound != nil && upperBound != nil && lowerBound! > upperBound!) {
            errors.append(.invalidGoal)
        }

        return errors.isEmpty ? .success : .failure(errors)
    }

    // MARK: - Private Methods

    private func containsInvalidGoalValue(_ values: [Double]) -> Bool {
        values.contains { value in
            value < 0 || !value.isFinite
        }
    }
}
