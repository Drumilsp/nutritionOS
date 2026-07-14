//
//  GetFoodsUseCase.swift
//  Nutri
//

import Foundation

struct GetFoodsUseCase {
    private let foodRepository: any FoodRepository

    init(foodRepository: any FoodRepository) {
        self.foodRepository = foodRepository
    }

    func execute(includeArchived: Bool = false) async throws -> [Food] {
        try await foodRepository.allFoods().filter { includeArchived || !$0.isArchived }
    }
}
