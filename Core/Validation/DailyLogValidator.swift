//
//  DailyLogValidator.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Validates daily logging actions.
struct DailyLogValidator {

    // MARK: - Public Methods

    func validateLoggedQuantity(_ quantity: Double) -> ValidationResult {
        quantity > 0 && quantity.isFinite ? .success : .failure([.invalidQuantity])
    }

    func validateWaterIntake(_ waterIntake: Double) -> ValidationResult {
        waterIntake >= 0 && waterIntake.isFinite ? .success : .failure([.invalidWaterIntake])
    }

    func validateNutritionProfile(_ nutritionProfile: NutritionProfile) -> ValidationResult {
        let containsInvalidNutrition = nutritionProfile.nutrientValues.contains { nutrientValue in
            nutrientValue.value < 0 || !nutrientValue.value.isFinite
        }

        return containsInvalidNutrition ? .failure([.invalidNutrition]) : .success
    }

    func validateDateRange(from startDate: Date, to endDate: Date) -> ValidationResult {
        startDate <= endDate ? .success : .failure([.invalidDateRange])
    }

    func validateEditable(_ dailyLog: DailyLog) -> ValidationResult {
        dailyLog.isCompleted ? .failure([.completedDay]) : .success
    }
}
