//
//  SearchMealsUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct SearchMealsUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository

    // MARK: - Initialization

    init(mealRepository: any MealRepository) {
        self.mealRepository = mealRepository
    }

    // MARK: - Public Methods

    func execute(query: String, includeArchived: Bool = false) async throws -> [Meal] {
        if includeArchived {
            return try await mealRepository.allMeals()
                .filter(\.isArchived)
                .filter { $0.name.localizedCaseInsensitiveContains(query) }
        }

        return try await mealRepository.searchMeals(query: query)
    }
}
