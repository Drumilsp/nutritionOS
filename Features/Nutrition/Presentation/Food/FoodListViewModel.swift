//
//  FoodListViewModel.swift
//  Nutri
//

import Foundation
import Observation

@MainActor
@Observable
final class FoodListViewModel {
    private let getFoodsUseCase: GetFoodsUseCase
    private let searchFoodsUseCase: SearchFoodsUseCase
    private let getFavoriteFoodsUseCase: GetFavoriteFoodsUseCase
    private let foodRepository: any FoodRepository

    private(set) var state: FoodListState = .loading

    init(
        getFoodsUseCase: GetFoodsUseCase,
        searchFoodsUseCase: SearchFoodsUseCase,
        getFavoriteFoodsUseCase: GetFavoriteFoodsUseCase,
        foodRepository: any FoodRepository
    ) {
        self.getFoodsUseCase = getFoodsUseCase
        self.searchFoodsUseCase = searchFoodsUseCase
        self.getFavoriteFoodsUseCase = getFavoriteFoodsUseCase
        self.foodRepository = foodRepository
    }

    func load(query: String = "", category: FoodCategory? = nil) async {
        state = .loading
        do {
            var foods = query.isEmpty
                ? try await getFoodsUseCase.execute()
                : try await searchFoodsUseCase.execute(query: query)
            if let category {
                foods = foods.filter { $0.category == category.rawValue }
            }
            let favorites = try await getFavoriteFoodsUseCase.execute()
            let recentlyUsed = try await foodRepository.recentlyUsedFoods(limit: 25)
            let categories = FoodCategory.allCases.filter { category in
                foods.contains { $0.category == category.rawValue }
            }
            state = foods.isEmpty ? .empty : .loaded(
                FoodListContent(
                    foods: foods,
                    favorites: favorites,
                    recentlyUsed: recentlyUsed,
                    categories: categories
                )
            )
        } catch {
            state = .error(message(for: error))
        }
    }

    private func message(for error: Error) -> String {
        error is ValidationFailure ? "Unable to load foods." : "Food storage is unavailable."
    }
}
