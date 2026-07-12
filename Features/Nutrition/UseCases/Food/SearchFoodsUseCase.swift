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
        let normalizedQuery = TextNormalizer.normalizedSpacing(query).lowercased()
        let foods = try await foodRepository.allFoods()
            .filter { includeArchived || !$0.isArchived }

        guard !normalizedQuery.isEmpty else {
            return foods.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }

        return foods
            .filter { food in
                food.name.lowercased().contains(normalizedQuery)
                    || (food.category?.lowercased().contains(normalizedQuery) ?? false)
            }
            .sorted { firstFood, secondFood in
                ranked(firstFood, query: normalizedQuery) < ranked(secondFood, query: normalizedQuery)
            }
    }

    // MARK: - Private Methods

    private func ranked(_ food: Food, query: String) -> Int {
        food.name.lowercased().hasPrefix(query) ? 0 : 1
    }
}
