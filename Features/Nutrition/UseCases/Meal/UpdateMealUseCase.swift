//
//  UpdateMealUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct UpdateMealUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository
    private let validator: MealValidator
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        mealRepository: any MealRepository,
        validator: MealValidator = MealValidator(),
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.mealRepository = mealRepository
        self.validator = validator
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(_ meal: Meal) async throws -> Meal {
        let normalizedMeal = validator.normalizedMeal(meal, updatedAt: dateProvider.now)
        try validator.validate(normalizedMeal).throwIfInvalid()
        try await validateDuplicateMeal(normalizedMeal)

        return try await mealRepository.update(normalizedMeal)
    }

    // MARK: - Private Methods

    private func validateDuplicateMeal(_ meal: Meal) async throws {
        let duplicateExists = try await mealRepository.allMeals().contains { existingMeal in
            existingMeal.id != meal.id
                && TextNormalizer.normalizedName(existingMeal.name) == meal.name
                && !existingMeal.isArchived
        }

        if duplicateExists {
            throw ValidationFailure(errors: [.duplicateMeal])
        }
    }
}
