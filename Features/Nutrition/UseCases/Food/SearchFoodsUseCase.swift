//
//  SearchFoodsUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct SearchFoodsUseCase {

    // MARK: - Properties

    private let foodRepository: any FoodRepository

    // MARK: - Initialization

    init(foodRepository: any FoodRepository) {
        self.foodRepository = foodRepository
    }

    // MARK: - Public Methods

    func execute(query: String, includeArchived: Bool = false) async throws -> [Food] {
        if includeArchived {
            return try await foodRepository.allFoods()
                .filter(\.isArchived)
                .filter { $0.name.localizedCaseInsensitiveContains(query) }
        }

        return try await foodRepository.searchFoods(query: query)
    }
}
