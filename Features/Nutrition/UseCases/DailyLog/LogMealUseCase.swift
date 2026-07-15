//
//  LogMealUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct LogMealUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository
    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider

    // MARK: - Initialization

    init(
        mealRepository: any MealRepository,
        dailyLogRepository: any DailyLogRepository,
        validator: DailyLogValidator = DailyLogValidator(),
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider()
    ) {
        self.mealRepository = mealRepository
        self.dailyLogRepository = dailyLogRepository
        self.validator = validator
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
    }

    // MARK: - Public Methods

    func execute(
        mealID: UUID,
        mealSlot: MealSlot,
        date: Date? = nil,
        notes: String? = nil
    ) async throws -> DailyLog {
        let logDate = date ?? dateProvider.now
        if try await dailyLogRepository.exists(date: logDate) {
            try validator.validateEditable(try await dailyLogRepository.log(date: logDate)).throwIfInvalid()
        }

        let meal = try await mealRepository.meal(id: mealID)
        let loggedMeal = LoggedMeal(
            id: uuidProvider.makeUUID(),
            mealID: meal.id,
            mealName: meal.name,
            loggedFoods: meal.mealItems.map { makeLoggedFood(from: $0, mealSlot: mealSlot) },
            mealSlot: mealSlot,
            createdAt: dateProvider.now,
            source: .mealTemplate,
            notes: TextNormalizer.normalizedOptionalText(notes)
        )

        let updatedLog = try await dailyLogRepository.addLoggedMeal(loggedMeal, to: logDate)
        _ = try await mealRepository.markUsed(id: mealID, at: dateProvider.now)
        return updatedLog
    }

    // MARK: - Private Methods

    private func makeLoggedFood(from mealItem: MealItem, mealSlot: MealSlot) -> LoggedFood {
        let food = mealItem.foodReference
        let multiplier = mealItem.quantity / food.referenceQuantity

        return LoggedFood(
            id: uuidProvider.makeUUID(),
            foodID: food.id,
            foodName: food.name,
            category: food.category,
            referenceQuantity: food.referenceQuantity,
            referenceUnit: food.referenceUnit,
            loggedQuantity: mealItem.quantity,
            nutritionProfileSnapshot: food.nutritionProfile.scaled(by: multiplier),
            mealSlot: mealSlot,
            createdAt: dateProvider.now,
            notes: food.notes
        )
    }
}
