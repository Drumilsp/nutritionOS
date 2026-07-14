//
//  MealListViewModel.swift
//  Nutri
//

import Foundation
import Observation

@MainActor
@Observable
final class MealListViewModel {
    private let getMealsUseCase: GetMealsUseCase
    private let searchMealsUseCase: SearchMealsUseCase
    private let getFavoriteMealsUseCase: GetFavoriteMealsUseCase
    private let getRecentlyUsedMealsUseCase: GetRecentlyUsedMealsUseCase

    private(set) var state: MealListState = .loading

    init(
        getMealsUseCase: GetMealsUseCase,
        searchMealsUseCase: SearchMealsUseCase,
        getFavoriteMealsUseCase: GetFavoriteMealsUseCase,
        getRecentlyUsedMealsUseCase: GetRecentlyUsedMealsUseCase
    ) {
        self.getMealsUseCase = getMealsUseCase
        self.searchMealsUseCase = searchMealsUseCase
        self.getFavoriteMealsUseCase = getFavoriteMealsUseCase
        self.getRecentlyUsedMealsUseCase = getRecentlyUsedMealsUseCase
    }

    func load(query: String = "") async {
        state = .loading
        do {
            let meals = query.isEmpty
                ? try await getMealsUseCase.execute()
                : try await searchMealsUseCase.execute(query: query)
            let favorites = try await getFavoriteMealsUseCase.execute()
            let recentlyUsed = try await getRecentlyUsedMealsUseCase.execute()
            state = meals.isEmpty ? .empty : .loaded(
                MealListContent(meals: meals, favorites: favorites, recentlyUsed: recentlyUsed)
            )
        } catch {
            state = .error("Meal storage is unavailable.")
        }
    }
}
