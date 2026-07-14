//
//  GetMealsUseCase.swift
//  Nutri
//

import Foundation

struct GetMealsUseCase {
    private let mealRepository: any MealRepository

    init(mealRepository: any MealRepository) {
        self.mealRepository = mealRepository
    }

    func execute(includeArchived: Bool = false) async throws -> [Meal] {
        try await mealRepository.allMeals().filter { includeArchived || !$0.isArchived }
    }
}
