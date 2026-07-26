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
    private let toggleFavoriteMealUseCase: ToggleFavoriteMealUseCase
    private let archiveMealUseCase: ArchiveMealUseCase
    private let restoreMealUseCase: RestoreMealUseCase
    private let deleteMealUseCase: DeleteMealUseCase
    private let duplicateMealUseCase: DuplicateMealUseCase

    private(set) var state: MealLibraryScreenState = .loading
    private var query = ""
    private var filter: MealLibraryFilter = .all
    private var sort: MealLibrarySort = .name

    init(
        getMealsUseCase: GetMealsUseCase,
        searchMealsUseCase: SearchMealsUseCase,
        getFavoriteMealsUseCase: GetFavoriteMealsUseCase,
        getRecentlyUsedMealsUseCase: GetRecentlyUsedMealsUseCase,
        toggleFavoriteMealUseCase: ToggleFavoriteMealUseCase,
        archiveMealUseCase: ArchiveMealUseCase,
        restoreMealUseCase: RestoreMealUseCase,
        deleteMealUseCase: DeleteMealUseCase,
        duplicateMealUseCase: DuplicateMealUseCase
    ) {
        self.getMealsUseCase = getMealsUseCase
        self.searchMealsUseCase = searchMealsUseCase
        self.getFavoriteMealsUseCase = getFavoriteMealsUseCase
        self.getRecentlyUsedMealsUseCase = getRecentlyUsedMealsUseCase
        self.toggleFavoriteMealUseCase = toggleFavoriteMealUseCase
        self.archiveMealUseCase = archiveMealUseCase
        self.restoreMealUseCase = restoreMealUseCase
        self.deleteMealUseCase = deleteMealUseCase
        self.duplicateMealUseCase = duplicateMealUseCase
    }

    func load(
        query: String = "",
        filter: MealLibraryFilter = .all,
        sort: MealLibrarySort = .name
    ) async {
        self.query = query
        self.filter = filter
        self.sort = sort
        state = .loading
        do {
            let meals = try await meals(query: query, filter: filter, sort: sort)
            state = meals.isEmpty ? .empty : .loaded(
                MealLibraryContent(meals: meals, selectedFilter: filter, selectedSort: sort)
            )
        } catch {
            state = .error("Meal storage is unavailable.")
        }
    }

    func refresh() async { await load(query: query, filter: filter, sort: sort) }

    func toggleFavorite(id: UUID) async { await perform { try await self.toggleFavoriteMealUseCase.execute(id: id) } }
    func archive(id: UUID) async { await perform { try await self.archiveMealUseCase.execute(id: id) } }
    func restore(id: UUID) async { await perform { try await self.restoreMealUseCase.execute(id: id) } }
    func delete(id: UUID) async { await perform { try await self.deleteMealUseCase.execute(id: id) } }
    func duplicate(id: UUID) async { await perform { try await self.duplicateMealUseCase.execute(id: id) } }

    private func meals(query: String, filter: MealLibraryFilter, sort: MealLibrarySort) async throws -> [Meal] {
        let includeArchived = filter == .archived
        let results = query.isEmpty
            ? try await getMealsUseCase.execute(includeArchived: includeArchived)
            : try await searchMealsUseCase.execute(query: query, includeArchived: includeArchived)
        let filtered: [Meal]
        switch filter {
        case .all, .archived:
            filtered = results
        case .favorites:
            let favoriteIDs = Set(try await getFavoriteMealsUseCase.execute().map(\.id))
            filtered = results.filter { favoriteIDs.contains($0.id) }
        }
        switch sort {
        case .name:
            return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .recentlyUsed:
            let orderedIDs = try await getRecentlyUsedMealsUseCase.execute(limit: filtered.count).map(\.id)
            return ordered(filtered, by: orderedIDs)
        case .recentlyUpdated:
            return filtered.sorted { $0.updatedAt > $1.updatedAt }
        case .createdDate:
            return filtered.sorted { $0.createdAt > $1.createdAt }
        }
    }

    private func ordered(_ meals: [Meal], by orderedIDs: [UUID]) -> [Meal] {
        let positions = Dictionary(uniqueKeysWithValues: orderedIDs.enumerated().map { ($1, $0) })
        return meals.sorted { (positions[$0.id] ?? .max) < (positions[$1.id] ?? .max) }
    }

    private func perform<Result>(_ action: () async throws -> Result) async {
        do {
            _ = try await action()
            await refresh()
        } catch {
            state = .error("Unable to update this meal.")
        }
    }
}
