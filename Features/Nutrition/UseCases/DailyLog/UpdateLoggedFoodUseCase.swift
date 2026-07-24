//
//  UpdateLoggedFoodUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct UpdateLoggedFoodUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        validator: DailyLogValidator = DailyLogValidator(),
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.validator = validator
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(
        loggedFood: LoggedFood,
        quantity: Double,
        mealSlot: MealSlot? = nil,
        date: Date? = nil,
        notes: String? = nil
    ) async throws -> DailyLog {
        try validator.validateLoggedQuantity(quantity).throwIfInvalid()
        let logDate = date ?? dateProvider.now
        try validator.validateEditable(try await dailyLogRepository.log(date: logDate)).throwIfInvalid()
        let multiplier = quantity / loggedFood.loggedQuantity
        let updatedLoggedFood = LoggedFood(
            id: loggedFood.id,
            foodID: loggedFood.foodID,
            foodName: loggedFood.foodName,
            category: loggedFood.category,
            referenceQuantity: loggedFood.referenceQuantity,
            referenceUnit: loggedFood.referenceUnit,
            loggedQuantity: quantity,
            nutritionProfileSnapshot: loggedFood.nutritionProfileSnapshot.scaled(by: multiplier),
            mealSlot: mealSlot ?? loggedFood.mealSlot,
            createdAt: loggedFood.createdAt,
            source: loggedFood.source,
            notes: TextNormalizer.normalizedOptionalText(notes) ?? loggedFood.notes
        )

        return try await dailyLogRepository.updateLoggedFood(updatedLoggedFood, on: logDate)
    }
}
