//
//  CopyYesterdayUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct CopyYesterdayUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider
    private let calendar: Calendar

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        validator: DailyLogValidator = DailyLogValidator(),
        dateProvider: any DateProvider = SystemDateProvider(),
        uuidProvider: any UUIDProvider = SystemUUIDProvider(),
        calendar: Calendar = .current
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.validator = validator
        self.dateProvider = dateProvider
        self.uuidProvider = uuidProvider
        self.calendar = calendar
    }

    // MARK: - Public Methods

    func execute() async throws -> DailyLog {
        let today = calendar.startOfDay(for: dateProvider.now)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let yesterdayLog = try await dailyLogRepository.log(date: yesterday)

        if try await dailyLogRepository.exists(date: today) {
            try validator.validateEditable(try await dailyLogRepository.log(date: today)).throwIfInvalid()
        }

        var updatedLog: DailyLog?

        for loggedFood in yesterdayLog.loggedFoods {
            updatedLog = try await dailyLogRepository.addLoggedFood(copy(loggedFood), to: today)
        }

        for loggedMeal in yesterdayLog.loggedMeals {
            updatedLog = try await dailyLogRepository.addLoggedMeal(copy(loggedMeal), to: today)
        }

        if let updatedLog {
            return updatedLog
        }

        if try await dailyLogRepository.exists(date: today) {
            return try await dailyLogRepository.log(date: today)
        }

        return try await dailyLogRepository.save(
            DailyLog(
                id: uuidProvider.makeUUID(),
                date: today,
                calorieGoalSnapshot: yesterdayLog.calorieGoalSnapshot,
                proteinGoalSnapshot: yesterdayLog.proteinGoalSnapshot,
                fatGoalSnapshot: yesterdayLog.fatGoalSnapshot,
                fibreGoalSnapshot: yesterdayLog.fibreGoalSnapshot,
                maintenanceCaloriesSnapshot: yesterdayLog.maintenanceCaloriesSnapshot,
                createdAt: dateProvider.now,
                updatedAt: dateProvider.now
            )
        )
    }

    // MARK: - Private Methods

    private func copy(_ loggedFood: LoggedFood) -> LoggedFood {
        LoggedFood(
            id: uuidProvider.makeUUID(),
            foodName: loggedFood.foodName,
            category: loggedFood.category,
            referenceQuantity: loggedFood.referenceQuantity,
            referenceUnit: loggedFood.referenceUnit,
            loggedQuantity: loggedFood.loggedQuantity,
            nutritionProfileSnapshot: loggedFood.nutritionProfileSnapshot,
            mealSlot: loggedFood.mealSlot,
            createdAt: dateProvider.now,
            notes: loggedFood.notes
        )
    }

    private func copy(_ loggedMeal: LoggedMeal) -> LoggedMeal {
        LoggedMeal(
            id: uuidProvider.makeUUID(),
            mealName: loggedMeal.mealName,
            loggedFoods: loggedMeal.loggedFoods.map(copy),
            mealSlot: loggedMeal.mealSlot,
            createdAt: dateProvider.now,
            notes: loggedMeal.notes
        )
    }
}
