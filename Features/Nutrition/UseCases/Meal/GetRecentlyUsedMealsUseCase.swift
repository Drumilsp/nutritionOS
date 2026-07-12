//
//  GetRecentlyUsedMealsUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct GetRecentlyUsedMealsUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository
    private let dailyLogRepository: any DailyLogRepository
    private let dateProvider: any DateProvider
    private let calendar: Calendar

    // MARK: - Initialization

    init(
        mealRepository: any MealRepository,
        dailyLogRepository: any DailyLogRepository,
        dateProvider: any DateProvider = SystemDateProvider(),
        calendar: Calendar = .current
    ) {
        self.mealRepository = mealRepository
        self.dailyLogRepository = dailyLogRepository
        self.dateProvider = dateProvider
        self.calendar = calendar
    }

    // MARK: - Public Methods

    func execute(daysBack: Int = 30, limit: Int = 10) async throws -> [Meal] {
        let today = calendar.startOfDay(for: dateProvider.now)
        let startDate = calendar.date(byAdding: .day, value: -max(daysBack, 0), to: today) ?? today
        let meals = try await mealRepository.allMeals().filter { !$0.isArchived }
        let mealsByName = Dictionary(uniqueKeysWithValues: meals.map { (TextNormalizer.normalizedName($0.name), $0) })
        let logs = try await dailyLogRepository.logs(from: startDate, to: today)
            .sorted { $0.date > $1.date }
        var recentlyUsedMeals: [Meal] = []
        var seenMealIDs = Set<UUID>()

        for log in logs {
            for loggedMeal in log.loggedMeals {
                guard let meal = mealsByName[TextNormalizer.normalizedName(loggedMeal.mealName)] else {
                    continue
                }

                if seenMealIDs.insert(meal.id).inserted {
                    recentlyUsedMeals.append(meal)
                }

                if recentlyUsedMeals.count == limit {
                    return recentlyUsedMeals
                }
            }
        }

        return recentlyUsedMeals
    }
}
