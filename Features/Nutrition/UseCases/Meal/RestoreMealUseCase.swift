//
//  RestoreMealUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct RestoreMealUseCase {

    // MARK: - Properties

    private let mealRepository: any MealRepository

    // MARK: - Initialization

    init(mealRepository: any MealRepository) {
        self.mealRepository = mealRepository
    }

    // MARK: - Public Methods

    func execute(id: UUID) async throws -> Meal {
        try await mealRepository.restoreMeal(id: id)
    }
}
