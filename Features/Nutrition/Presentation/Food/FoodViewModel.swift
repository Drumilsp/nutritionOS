import Foundation
import Observation

@MainActor
@Observable
final class FoodViewModel {

    // MARK: - Properties

    private let getFoodsUseCase: GetFoodsUseCase
    private let searchFoodsUseCase: SearchFoodsUseCase
    private let getFavoriteFoodsUseCase: GetFavoriteFoodsUseCase
    private let getRecentlyUsedFoodsUseCase: GetRecentlyUsedFoodsUseCase
    private let toggleFavoriteFoodUseCase: ToggleFavoriteFoodUseCase
    private let archiveFoodUseCase: ArchiveFoodUseCase
    private let restoreFoodUseCase: RestoreFoodUseCase
    private let deleteFoodUseCase: DeleteFoodUseCase
    private let duplicateFoodUseCase: DuplicateFoodUseCase

    private(set) var state: FoodLibraryScreenState = .loading
    private var query = ""
    private var filter: FoodLibraryFilter = .all
    private var sort: FoodLibrarySort = .name
    private var archivedFoodIDForUndo: UUID?

    var canUndoArchive: Bool { archivedFoodIDForUndo != nil }

    // MARK: - Initialization

    init(
        getFoodsUseCase: GetFoodsUseCase,
        searchFoodsUseCase: SearchFoodsUseCase,
        getFavoriteFoodsUseCase: GetFavoriteFoodsUseCase,
        getRecentlyUsedFoodsUseCase: GetRecentlyUsedFoodsUseCase,
        toggleFavoriteFoodUseCase: ToggleFavoriteFoodUseCase,
        archiveFoodUseCase: ArchiveFoodUseCase,
        restoreFoodUseCase: RestoreFoodUseCase,
        deleteFoodUseCase: DeleteFoodUseCase,
        duplicateFoodUseCase: DuplicateFoodUseCase
    ) {
        self.getFoodsUseCase = getFoodsUseCase
        self.searchFoodsUseCase = searchFoodsUseCase
        self.getFavoriteFoodsUseCase = getFavoriteFoodsUseCase
        self.getRecentlyUsedFoodsUseCase = getRecentlyUsedFoodsUseCase
        self.toggleFavoriteFoodUseCase = toggleFavoriteFoodUseCase
        self.archiveFoodUseCase = archiveFoodUseCase
        self.restoreFoodUseCase = restoreFoodUseCase
        self.deleteFoodUseCase = deleteFoodUseCase
        self.duplicateFoodUseCase = duplicateFoodUseCase
    }

    // MARK: - Public Methods

    func load(
        query: String = "",
        filter: FoodLibraryFilter = .all,
        sort: FoodLibrarySort = .name
    ) async {
        self.query = query
        self.filter = filter
        self.sort = sort
        state = .loading

        do {
            let foods = try await foods(query: query, filter: filter, sort: sort)
            let categories = try await availableCategories(for: filter)
            state = foods.isEmpty
                ? .empty
                : .loaded(
                    FoodLibraryContent(
                        foods: foods,
                        categories: categories,
                        selectedFilter: filter,
                        selectedSort: sort
                    )
                )
        } catch {
            state = .error("Food storage is unavailable.")
        }
    }

    func refresh() async {
        await load(query: query, filter: filter, sort: sort)
    }

    func toggleFavorite(id: UUID) async {
        await perform { try await self.toggleFavoriteFoodUseCase.execute(id: id) }
    }

    func archive(id: UUID) async {
        do {
            _ = try await archiveFoodUseCase.execute(id: id)
            archivedFoodIDForUndo = id
            await refresh()
        } catch {
            state = .error("Unable to archive this food.")
        }
    }

    func undoArchive() async {
        guard let archivedFoodIDForUndo else { return }

        do {
            _ = try await restoreFoodUseCase.execute(id: archivedFoodIDForUndo)
            self.archivedFoodIDForUndo = nil
            await refresh()
        } catch {
            state = .error("Unable to restore this food.")
        }
    }

    func discardArchiveUndo() {
        archivedFoodIDForUndo = nil
    }

    func restore(id: UUID) async {
        await perform { try await self.restoreFoodUseCase.execute(id: id) }
    }

    func delete(id: UUID) async {
        await perform { try await self.deleteFoodUseCase.execute(id: id) }
    }

    func duplicate(id: UUID) async {
        await perform { try await self.duplicateFoodUseCase.execute(id: id) }
    }

    // MARK: - Private Methods

    private func foods(
        query: String,
        filter: FoodLibraryFilter,
        sort: FoodLibrarySort
    ) async throws -> [Food] {
        let includeArchived = filter == .archived
        let results = query.isEmpty
            ? try await getFoodsUseCase.execute(includeArchived: includeArchived)
            : try await searchFoodsUseCase.execute(
                query: query,
                includeArchived: includeArchived
            )

        let filteredFoods = try await filtered(results, by: filter)
        return try await sortFoods(filteredFoods, by: sort)
    }

    private func filtered(
        _ foods: [Food],
        by filter: FoodLibraryFilter
    ) async throws -> [Food] {
        switch filter {
        case .all, .archived:
            return foods
        case .favorites:
            let favoriteIDs = Set(try await getFavoriteFoodsUseCase.execute().map(\.id))
            return foods.filter { favoriteIDs.contains($0.id) }
        case .category(let category):
            return foods.filter { $0.category == category.rawValue }
        }
    }

    private func sortFoods(
        _ foods: [Food],
        by sort: FoodLibrarySort
    ) async throws -> [Food] {
        switch sort {
        case .name:
            return foods.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .recentlyUsed:
            let recentIDs = try await getRecentlyUsedFoodsUseCase.execute(limit: foods.count).map(\.id)
            let positions = Dictionary(uniqueKeysWithValues: recentIDs.enumerated().map { ($1, $0) })
            return foods.sorted {
                (positions[$0.id] ?? .max) < (positions[$1.id] ?? .max)
            }
        }
    }

    private func availableCategories(
        for filter: FoodLibraryFilter
    ) async throws -> [FoodCategory] {
        let includeArchived = filter == .archived
        let foods = try await getFoodsUseCase.execute(includeArchived: includeArchived)
        return FoodCategory.allCases.filter { category in
            foods.contains { $0.category == category.rawValue }
        }
    }

    private func perform<Result>(_ action: () async throws -> Result) async {
        do {
            _ = try await action()
            await refresh()
        } catch {
            state = .error("Unable to update this food.")
        }
    }
}
