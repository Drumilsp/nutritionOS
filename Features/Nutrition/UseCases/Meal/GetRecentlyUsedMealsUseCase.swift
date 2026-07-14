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

    // MARK: - Initialization

    init(
        mealRepository: any MealRepository,
        dailyLogRepository _: (any DailyLogRepository)? = nil,
        dateProvider _: any DateProvider = SystemDateProvider(),
        calendar _: Calendar = .current
    ) {
        self.mealRepository = mealRepository
    }

    // MARK: - Public Methods

    func execute(daysBack _: Int = 30, limit: Int = 20) async throws -> [Meal] {
        try await mealRepository.recentlyUsedMeals(limit: limit)
    }
}
