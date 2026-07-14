//
//  ToggleFavoriteFoodUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct ToggleFavoriteFoodUseCase {

    // MARK: - Properties

    private let foodRepository: any FoodRepository
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        foodRepository: any FoodRepository,
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.foodRepository = foodRepository
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(id: UUID) async throws -> Food {
        let food = try await foodRepository.food(id: id)
        return try await foodRepository.setFavorite(id: food.id, isFavorite: !food.isFavorite)
    }
}
