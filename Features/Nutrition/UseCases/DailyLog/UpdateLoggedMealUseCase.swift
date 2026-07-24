//
//  UpdateLoggedMealUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct UpdateLoggedMealUseCase {

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
        loggedMeal: LoggedMeal,
        mealSlot: MealSlot,
        servingMultiplier: Double? = nil,
        date: Date? = nil,
        notes: String? = nil
    ) async throws -> DailyLog {
        let updatedServingMultiplier = servingMultiplier ?? loggedMeal.servingMultiplier
        try validator.validateServingMultiplier(updatedServingMultiplier).throwIfInvalid()
        let logDate = date ?? dateProvider.now
        try validator.validateEditable(try await dailyLogRepository.log(date: logDate)).throwIfInvalid()
        let nutritionMultiplier = updatedServingMultiplier / loggedMeal.servingMultiplier
        let updatedLoggedMeal = LoggedMeal(
            id: loggedMeal.id,
            mealID: loggedMeal.mealID,
            mealName: loggedMeal.mealName,
            loggedFoods: loggedMeal.loggedFoods.map { loggedFood in
                LoggedFood(
                    id: loggedFood.id,
                    foodID: loggedFood.foodID,
                    foodName: loggedFood.foodName,
                    category: loggedFood.category,
                    referenceQuantity: loggedFood.referenceQuantity,
                    referenceUnit: loggedFood.referenceUnit,
                    loggedQuantity: loggedFood.loggedQuantity * nutritionMultiplier,
                    nutritionProfileSnapshot: loggedFood.nutritionProfileSnapshot.scaled(by: nutritionMultiplier),
                    mealSlot: mealSlot,
                    createdAt: loggedFood.createdAt,
                    source: loggedFood.source,
                    notes: loggedFood.notes
                )
            },
            mealSlot: mealSlot,
            servingMultiplier: updatedServingMultiplier,
            createdAt: loggedMeal.createdAt,
            source: loggedMeal.source,
            notes: TextNormalizer.normalizedOptionalText(notes) ?? loggedMeal.notes
        )

        return try await dailyLogRepository.updateLoggedMeal(updatedLoggedMeal, on: logDate)
    }
}
