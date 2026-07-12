//
//  GetFavoriteMealsUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct GetFavoriteMealsUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository

    // MARK: - Initialization

    init(mealRepository: any MealRepository) {
        self.mealRepository = mealRepository
    }

    // MARK: - Public Methods

    func execute() async throws -> [Meal] {
        try await mealRepository.favoriteMeals()
            .filter { !$0.isArchived }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
