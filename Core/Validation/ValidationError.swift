//
//  ValidationError.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Represents business validation failures from the use case layer.
enum ValidationError: Error, Equatable {
    case emptyName
    case invalidQuantity
    case invalidServingUnit
    case invalidNutrition
    case systemFoodReadOnly
    case invalidDateOfBirth
    case invalidHeight
    case invalidWeight
    case invalidGoal
    case invalidPreference
    case duplicateFood
    case duplicateMeal
    case mealHasNoItems
    case invalidWaterIntake
    case invalidDateRange
    case completedDay
}
