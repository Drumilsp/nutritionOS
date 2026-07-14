//
//  CreateMealUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct CreateMealUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository
    private let validator: MealValidator
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider

    // MARK: - Initialization

    init(
        mealRepository: any MealRepository,
        validator: MealValidator = MealValidator(),
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider()
    ) {
        self.mealRepository = mealRepository
        self.validator = validator
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
    }

    // MARK: - Public Methods

    func execute(_ meal: Meal) async throws -> Meal {
        let now = dateProvider.now
        let normalizedMeal = validator.normalizedMeal(
            Meal(
                id: uuidProvider.makeUUID(),
                name: meal.name,
                mealItems: meal.mealItems,
                notes: meal.notes,
                isFavorite: meal.isFavorite,
                isArchived: false,
                lastUsedAt: nil,
                createdAt: now,
                updatedAt: now
            )
        )

        try validator.validate(normalizedMeal).throwIfInvalid()
        try await validateDuplicateMeal(named: normalizedMeal.name)

        return try await mealRepository.save(normalizedMeal)
    }

    // MARK: - Private Methods

    private func validateDuplicateMeal(named name: String) async throws {
        let duplicateExists = try await mealRepository.allMeals().contains { meal in
            TextNormalizer.normalizedName(meal.name) == name && !meal.isArchived
        }

        if duplicateExists {
            throw ValidationFailure(errors: [.duplicateMeal])
        }
    }
}
