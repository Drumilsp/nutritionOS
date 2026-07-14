//
//  UpdateFoodUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct UpdateFoodUseCase {

    // MARK: - Properties

    private let foodRepository: any FoodRepository
    private let validator: FoodValidator
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        foodRepository: any FoodRepository,
        validator: FoodValidator = FoodValidator(),
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.foodRepository = foodRepository
        self.validator = validator
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(_ food: Food) async throws -> Food {
        let existingFood = try await foodRepository.food(id: food.id)
        if existingFood.isSystemFood {
            throw ValidationFailure(errors: [.systemFoodReadOnly])
        }
        let normalizedFood = validator.normalizedFood(food, updatedAt: dateProvider.now)
        try validator.validate(normalizedFood).throwIfInvalid()
        try await validateDuplicateFood(normalizedFood)

        return try await foodRepository.update(normalizedFood)
    }

    // MARK: - Private Methods

    private func validateDuplicateFood(_ food: Food) async throws {
        let duplicateExists = try await foodRepository.allFoods().contains { existingFood in
            existingFood.id != food.id
                && TextNormalizer.normalizedName(existingFood.name) == food.name
                && !existingFood.isArchived
        }

        if duplicateExists {
            throw ValidationFailure(errors: [.duplicateFood])
        }
    }
}
