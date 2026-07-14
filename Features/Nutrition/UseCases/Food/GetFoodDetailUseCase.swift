//
//  GetFoodDetailUseCase.swift
//  Nutri
//

import Foundation

struct GetFoodDetailUseCase {
    private let foodRepository: any FoodRepository

    init(foodRepository: any FoodRepository) {
        self.foodRepository = foodRepository
    }

    func execute(id: UUID) async throws -> Food {
        try await foodRepository.food(id: id)
    }
}
