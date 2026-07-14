//
//  GetMealDetailUseCase.swift
//  Nutri
//

import Foundation

struct GetMealDetailUseCase {
    private let mealRepository: any MealRepository

    init(mealRepository: any MealRepository) {
        self.mealRepository = mealRepository
    }

    func execute(id: UUID) async throws -> Meal {
        try await mealRepository.meal(id: id)
    }
}
