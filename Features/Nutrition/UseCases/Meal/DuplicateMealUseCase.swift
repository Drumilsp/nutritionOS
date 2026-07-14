//
//  DuplicateMealUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct DuplicateMealUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository
    private let validator: MealValidator
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider

    // MARK: - Initialization

    init(
        mealRepository: any MealRepository,
        validator: MealValidator = MealValidator(),
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider()
    ) {
        self.mealRepository = mealRepository
        self.validator = validator
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
    }

    // MARK: - Public Methods

    func execute(id: UUID) async throws -> Meal {
        let sourceMeal = try await mealRepository.meal(id: id)
        let now = dateProvider.now
        let copiedMeal = Meal(
            id: uuidProvider.makeUUID(),
            name: "\(sourceMeal.name) Copy",
            mealItems: sourceMeal.mealItems.map { mealItem in
                MealItem(
                    id: uuidProvider.makeUUID(),
                    foodReference: mealItem.foodReference,
                    quantity: mealItem.quantity
                )
            },
            notes: sourceMeal.notes,
            isFavorite: false,
            isArchived: false,
            lastUsedAt: nil,
            createdAt: now,
            updatedAt: now
        )
        let normalizedMeal = validator.normalizedMeal(copiedMeal)

        try validator.validate(normalizedMeal).throwIfInvalid()

        return try await mealRepository.save(normalizedMeal)
    }
}
