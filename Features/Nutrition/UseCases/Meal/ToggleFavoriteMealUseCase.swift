//
//  ToggleFavoriteMealUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct ToggleFavoriteMealUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        mealRepository: any MealRepository,
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.mealRepository = mealRepository
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(id: UUID) async throws -> Meal {
        let meal = try await mealRepository.meal(id: id)
        let updatedMeal = Meal(
            id: meal.id,
            name: meal.name,
            mealItems: meal.mealItems,
            notes: meal.notes,
            isFavorite: !meal.isFavorite,
            isArchived: meal.isArchived,
            createdAt: meal.createdAt,
            updatedAt: dateProvider.now
        )

        return try await mealRepository.update(updatedMeal)
    }
}
