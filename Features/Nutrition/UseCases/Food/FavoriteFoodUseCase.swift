//
//  FavoriteFoodUseCase.swift
//  Nutri
//

import Foundation

struct FavoriteFoodUseCase {
    private let foodRepository: any FoodRepository

    init(foodRepository: any FoodRepository) {
        self.foodRepository = foodRepository
    }

    func execute(id: UUID, isFavorite: Bool) async throws -> Food {
        try await foodRepository.setFavorite(id: id, isFavorite: isFavorite)
    }
}
