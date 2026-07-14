//
//  FoodDetailViewModel.swift
//  Nutri
//

import Foundation
import Observation

@MainActor
@Observable
final class FoodDetailViewModel {
    private let getFoodDetailUseCase: GetFoodDetailUseCase
    private let favoriteFoodUseCase: FavoriteFoodUseCase
    private let archiveFoodUseCase: ArchiveFoodUseCase
    private let duplicateFoodUseCase: DuplicateFoodUseCase
    private let deleteFoodUseCase: DeleteFoodUseCase

    private(set) var state: FoodDetailState = .loading

    init(
        getFoodDetailUseCase: GetFoodDetailUseCase,
        favoriteFoodUseCase: FavoriteFoodUseCase,
        archiveFoodUseCase: ArchiveFoodUseCase,
        duplicateFoodUseCase: DuplicateFoodUseCase,
        deleteFoodUseCase: DeleteFoodUseCase
    ) {
        self.getFoodDetailUseCase = getFoodDetailUseCase
        self.favoriteFoodUseCase = favoriteFoodUseCase
        self.archiveFoodUseCase = archiveFoodUseCase
        self.duplicateFoodUseCase = duplicateFoodUseCase
        self.deleteFoodUseCase = deleteFoodUseCase
    }

    func load(id: UUID) async {
        state = .loading
        do { state = .loaded(try await getFoodDetailUseCase.execute(id: id)) }
        catch { state = .error("Unable to load this food.") }
    }

    func setFavorite(id: UUID, isFavorite: Bool) async {
        do { state = .loaded(try await favoriteFoodUseCase.execute(id: id, isFavorite: isFavorite)) }
        catch { state = .error("Unable to update the favorite.") }
    }

    func archive(id: UUID) async {
        do { state = .archived(try await archiveFoodUseCase.execute(id: id)) }
        catch { state = .error("Unable to archive this food.") }
    }

    func duplicate(id: UUID) async -> Food? {
        do { return try await duplicateFoodUseCase.execute(id: id) }
        catch { state = .error("Unable to duplicate this food."); return nil }
    }

    func delete(id: UUID) async {
        do { try await deleteFoodUseCase.execute(id: id); state = .deleted }
        catch { state = .error("Unable to delete this food.") }
    }
}
