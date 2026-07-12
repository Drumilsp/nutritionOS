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
        date: Date? = nil,
        notes: String? = nil
    ) async throws -> DailyLog {
        let logDate = date ?? dateProvider.now
        try validator.validateEditable(try await dailyLogRepository.log(date: logDate)).throwIfInvalid()
        let updatedLoggedMeal = LoggedMeal(
            id: loggedMeal.id,
            mealName: loggedMeal.mealName,
            loggedFoods: loggedMeal.loggedFoods.map { loggedFood in
                LoggedFood(
                    id: loggedFood.id,
                    foodName: loggedFood.foodName,
                    category: loggedFood.category,
                    referenceQuantity: loggedFood.referenceQuantity,
                    referenceUnit: loggedFood.referenceUnit,
                    loggedQuantity: loggedFood.loggedQuantity,
                    nutritionProfileSnapshot: loggedFood.nutritionProfileSnapshot,
                    mealSlot: mealSlot,
                    createdAt: loggedFood.createdAt,
                    notes: loggedFood.notes
                )
            },
            mealSlot: mealSlot,
            createdAt: loggedMeal.createdAt,
            notes: TextNormalizer.normalizedOptionalText(notes) ?? loggedMeal.notes
        )

        return try await dailyLogRepository.updateLoggedMeal(updatedLoggedMeal, on: logDate)
    }
}
