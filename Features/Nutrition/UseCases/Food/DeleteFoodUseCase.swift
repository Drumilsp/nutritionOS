//
//  DeleteFoodUseCase.swift
//  Nutri
//

import Foundation

struct DeleteFoodUseCase {
    private let foodRepository: any FoodRepository

    init(foodRepository: any FoodRepository) {
        self.foodRepository = foodRepository
    }

    func execute(id: UUID) async throws {
        let food = try await foodRepository.food(id: id)
        if food.isSystemFood {
            throw ValidationFailure(errors: [.systemFoodReadOnly])
        }
        try await foodRepository.deleteFood(id: id)
    }
}
