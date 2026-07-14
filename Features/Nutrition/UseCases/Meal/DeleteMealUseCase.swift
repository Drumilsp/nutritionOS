//
//  DeleteMealUseCase.swift
//  Nutri
//

import Foundation

struct DeleteMealUseCase {
    private let mealRepository: any MealRepository

    init(mealRepository: any MealRepository) {
        self.mealRepository = mealRepository
    }

    func execute(id: UUID) async throws {
        try await mealRepository.deleteMeal(id: id)
    }
}
