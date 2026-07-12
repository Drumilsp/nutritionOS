//
//  GetFavoriteFoodsUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct GetFavoriteFoodsUseCase {

    // MARK: - Properties

    private let foodRepository: any FoodRepository

    // MARK: - Initialization

    init(foodRepository: any FoodRepository) {
        self.foodRepository = foodRepository
    }

    // MARK: - Public Methods

    func execute() async throws -> [Food] {
        try await foodRepository.favoriteFoods()
            .filter { !$0.isArchived }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
