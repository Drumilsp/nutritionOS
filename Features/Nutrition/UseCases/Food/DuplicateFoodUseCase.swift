//
//  DuplicateFoodUseCase.swift
//  Nutri
//

import Foundation

struct DuplicateFoodUseCase {
    private let foodRepository: any FoodRepository
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider

    init(
        foodRepository: any FoodRepository,
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider()
    ) {
        self.foodRepository = foodRepository
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
    }

    func execute(id: UUID) async throws -> Food {
        let food = try await foodRepository.food(id: id)
        let now = dateProvider.now
        let duplicate = Food(
            id: uuidProvider.makeUUID(),
            name: "\(food.name) Copy",
            category: food.category,
            referenceQuantity: food.referenceQuantity,
            referenceUnit: food.referenceUnit,
            nutritionProfile: food.nutritionProfile,
            notes: food.notes,
            isFavorite: false,
            isArchived: false,
            createdAt: now,
            updatedAt: now
        )
        return try await foodRepository.save(duplicate)
    }
}
