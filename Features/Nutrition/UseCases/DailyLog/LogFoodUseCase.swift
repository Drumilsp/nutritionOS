//
//  LogFoodUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct LogFoodUseCase {

    // MARK: - Properties

    private let foodRepository: any FoodRepository
    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider

    // MARK: - Initialization

    init(
        foodRepository: any FoodRepository,
        dailyLogRepository: any DailyLogRepository,
        validator: DailyLogValidator = DailyLogValidator(),
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider()
    ) {
        self.foodRepository = foodRepository
        self.dailyLogRepository = dailyLogRepository
        self.validator = validator
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
    }

    // MARK: - Public Methods

    func execute(
        foodID: UUID,
        quantity: Double,
        mealSlot: MealSlot,
        date: Date? = nil,
        notes: String? = nil
    ) async throws -> DailyLog {
        try validator.validateLoggedQuantity(quantity).throwIfInvalid()
        let logDate = date ?? dateProvider.now
        try await validator.validateEditable(currentLog(on: logDate)).throwIfInvalid()
        let food = try await foodRepository.food(id: foodID)
        let loggedFood = makeLoggedFood(
            from: food,
            quantity: quantity,
            mealSlot: mealSlot,
            notes: notes
        )

        return try await dailyLogRepository.addLoggedFood(loggedFood, to: logDate)
    }

    // MARK: - Private Methods

    private func currentLog(on date: Date) async throws -> DailyLog {
        if try await dailyLogRepository.exists(date: date) {
            return try await dailyLogRepository.log(date: date)
        }

        return DailyLog(
            id: uuidProvider.makeUUID(),
            date: date,
            calorieGoalSnapshot: 0,
            proteinGoalSnapshot: 0,
            fatGoalSnapshot: 0,
            fibreGoalSnapshot: 0,
            maintenanceCaloriesSnapshot: 0,
            createdAt: dateProvider.now,
            updatedAt: dateProvider.now
        )
    }

    private func makeLoggedFood(
        from food: Food,
        quantity: Double,
        mealSlot: MealSlot,
        notes: String?
    ) -> LoggedFood {
        let multiplier = quantity / food.referenceQuantity

        return LoggedFood(
            id: uuidProvider.makeUUID(),
            foodName: food.name,
            category: food.category,
            referenceQuantity: food.referenceQuantity,
            referenceUnit: food.referenceUnit,
            loggedQuantity: quantity,
            nutritionProfileSnapshot: food.nutritionProfile.scaled(by: multiplier),
            mealSlot: mealSlot,
            createdAt: dateProvider.now,
            notes: TextNormalizer.normalizedOptionalText(notes)
        )
    }
}
