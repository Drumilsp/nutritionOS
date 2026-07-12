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
        let normalizedQuery = TextNormalizer.normalizedSpacing(query).lowercased()
        let meals = try await mealRepository.allMeals()
            .filter { includeArchived || !$0.isArchived }

        guard !normalizedQuery.isEmpty else {
            return meals.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }

        return meals
            .filter { meal in
                meal.name.lowercased().contains(normalizedQuery)
                    || meal.mealItems.contains { $0.foodReference.name.lowercased().contains(normalizedQuery) }
            }
            .sorted { firstMeal, secondMeal in
                ranked(firstMeal, query: normalizedQuery) < ranked(secondMeal, query: normalizedQuery)
            }
    }

    // MARK: - Private Methods

    private func ranked(_ meal: Meal, query: String) -> Int {
        meal.name.lowercased().hasPrefix(query) ? 0 : 1
    }
}
