//
//  MealValidator.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Validates and safely normalizes meal template input.
struct MealValidator {

    // MARK: - Public Methods

    func normalizedMeal(_ meal: Meal, updatedAt: Date? = nil) -> Meal {
        Meal(
            id: meal.id,
            name: TextNormalizer.normalizedName(meal.name),
            mealItems: meal.mealItems,
            notes: TextNormalizer.normalizedOptionalText(meal.notes),
            isFavorite: meal.isFavorite,
            isArchived: meal.isArchived,
            createdAt: meal.createdAt,
            updatedAt: updatedAt ?? meal.updatedAt
        )
    }

    func validate(_ meal: Meal) -> ValidationResult {
        var errors: [ValidationError] = []

        if TextNormalizer.normalizedSpacing(meal.name).isEmpty {
            errors.append(.emptyName)
        }

        if meal.mealItems.isEmpty {
            errors.append(.mealHasNoItems)
        }

        if meal.mealItems.contains(where: { $0.quantity <= 0 || !$0.quantity.isFinite }) {
            errors.append(.invalidQuantity)
        }

        if meal.mealItems.contains(where: { !ServingUnit.validNames.contains($0.servingUnit.name) }) {
            errors.append(.invalidServingUnit)
        }

        if meal.mealItems.contains(where: { containsInvalidNutrition($0.foodReference.nutritionProfile) }) {
            errors.append(.invalidNutrition)
        }

        return errors.isEmpty ? .success : .failure(errors)
    }

    // MARK: - Private Methods

    private func containsInvalidNutrition(_ profile: NutritionProfile) -> Bool {
        profile.nutrientValues.contains { nutrientValue in
            nutrientValue.value < 0 || !nutrientValue.value.isFinite
        }
    }
}
