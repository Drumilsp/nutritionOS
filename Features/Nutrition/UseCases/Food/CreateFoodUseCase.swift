//
//  CreateFoodUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct CreateFoodUseCase {

    // MARK: - Properties

    private let foodRepository: any FoodRepository
    private let validator: FoodValidator
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider

    // MARK: - Initialization

    init(
        foodRepository: any FoodRepository,
        validator: FoodValidator = FoodValidator(),
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider()
    ) {
        self.foodRepository = foodRepository
        self.validator = validator
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
    }

    // MARK: - Public Methods

    func execute(_ food: Food) async throws -> Food {
        let now = dateProvider.now
        let normalizedFood = validator.normalizedFood(
            Food(
                id: uuidProvider.makeUUID(),
                name: food.name,
                category: food.category,
                referenceQuantity: food.referenceQuantity,
                referenceUnit: food.referenceUnit,
                nutritionProfile: food.nutritionProfile,
                notes: food.notes,
                isSystemFood: false,
                isFavorite: food.isFavorite,
                isArchived: false,
                lastUsedAt: nil,
                createdAt: now,
                updatedAt: now
            )
        )

        try validator.validate(normalizedFood).throwIfInvalid()
        try await validateDuplicateFood(named: normalizedFood.name)

        return try await foodRepository.save(normalizedFood)
    }

    // MARK: - Private Methods

    private func validateDuplicateFood(named name: String) async throws {
        let duplicateExists = try await foodRepository.allFoods().contains { food in
            TextNormalizer.normalizedName(food.name) == name && !food.isArchived
        }

        if duplicateExists {
            throw ValidationFailure(errors: [.duplicateFood])
        }
    }
}
