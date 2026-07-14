//
//  FavoriteMealUseCase.swift
//  Nutri
//

import Foundation

struct FavoriteMealUseCase {
    private let mealRepository: any MealRepository

    init(mealRepository: any MealRepository) {
        self.mealRepository = mealRepository
    }

    func execute(id: UUID, isFavorite: Bool) async throws -> Meal {
        try await mealRepository.setFavorite(id: id, isFavorite: isFavorite)
    }
}
