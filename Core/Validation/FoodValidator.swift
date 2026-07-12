//
//  FoodValidator.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Validates and safely normalizes food template input.
struct FoodValidator {

    // MARK: - Public Methods

    func normalizedFood(_ food: Food, updatedAt: Date? = nil) -> Food {
        Food(
            id: food.id,
            name: TextNormalizer.normalizedName(food.name),
            category: TextNormalizer.normalizedOptionalText(food.category),
            referenceQuantity: food.referenceQuantity,
            referenceUnit: food.referenceUnit,
            nutritionProfile: food.nutritionProfile,
            notes: TextNormalizer.normalizedOptionalText(food.notes),
            isFavorite: food.isFavorite,
            isArchived: food.isArchived,
            createdAt: food.createdAt,
            updatedAt: updatedAt ?? food.updatedAt
        )
    }

    func validate(_ food: Food) -> ValidationResult {
        var errors: [ValidationError] = []

        if TextNormalizer.normalizedSpacing(food.name).isEmpty {
            errors.append(.emptyName)
        }

        if food.referenceQuantity <= 0 || !food.referenceQuantity.isFinite {
            errors.append(.invalidQuantity)
        }

        if containsInvalidNutrition(food.nutritionProfile) {
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
