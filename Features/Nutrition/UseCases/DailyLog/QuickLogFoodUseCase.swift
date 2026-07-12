//
//  QuickLogFoodUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct QuickLogFoodUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        validator: DailyLogValidator = DailyLogValidator(),
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider()
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.validator = validator
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
    }

    // MARK: - Public Methods

    func execute(
        name: String,
        quantity: Double,
        unit: ServingUnit,
        nutritionProfile: NutritionProfile,
        mealSlot: MealSlot,
        date: Date? = nil,
        notes: String? = nil
    ) async throws -> DailyLog {
        let normalizedName = TextNormalizer.normalizedName(name)
        if normalizedName.isEmpty {
            throw ValidationFailure(errors: [.emptyName])
        }

        try validator.validateLoggedQuantity(quantity).throwIfInvalid()
        try validator.validateNutritionProfile(nutritionProfile).throwIfInvalid()
        let logDate = date ?? dateProvider.now
        if try await dailyLogRepository.exists(date: logDate) {
            try validator.validateEditable(try await dailyLogRepository.log(date: logDate)).throwIfInvalid()
        }

        let loggedFood = LoggedFood(
            id: uuidProvider.makeUUID(),
            foodName: normalizedName,
            referenceQuantity: quantity,
            referenceUnit: unit,
            loggedQuantity: quantity,
            nutritionProfileSnapshot: nutritionProfile,
            mealSlot: mealSlot,
            createdAt: dateProvider.now,
            notes: TextNormalizer.normalizedOptionalText(notes)
        )

        return try await dailyLogRepository.addLoggedFood(loggedFood, to: logDate)
    }
}
