//
//  MealDetailViewModel.swift
//  Nutri
//

import Foundation
import Observation

@MainActor
@Observable
final class MealDetailViewModel {
    private let getMealDetailUseCase: GetMealDetailUseCase
    private let favoriteMealUseCase: FavoriteMealUseCase
    private let archiveMealUseCase: ArchiveMealUseCase
    private let duplicateMealUseCase: DuplicateMealUseCase
    private let deleteMealUseCase: DeleteMealUseCase

    private(set) var state: MealDetailState = .loading

    init(
        getMealDetailUseCase: GetMealDetailUseCase,
        favoriteMealUseCase: FavoriteMealUseCase,
        archiveMealUseCase: ArchiveMealUseCase,
        duplicateMealUseCase: DuplicateMealUseCase,
        deleteMealUseCase: DeleteMealUseCase
    ) {
        self.getMealDetailUseCase = getMealDetailUseCase
        self.favoriteMealUseCase = favoriteMealUseCase
        self.archiveMealUseCase = archiveMealUseCase
        self.duplicateMealUseCase = duplicateMealUseCase
        self.deleteMealUseCase = deleteMealUseCase
    }

    func load(id: UUID) async {
        state = .loading
        do { state = .loaded(try await getMealDetailUseCase.execute(id: id)) }
        catch { state = .error("Unable to load this meal.") }
    }

    func setFavorite(id: UUID, isFavorite: Bool) async {
        do { state = .loaded(try await favoriteMealUseCase.execute(id: id, isFavorite: isFavorite)) }
        catch { state = .error("Unable to update the favorite.") }
    }

    func archive(id: UUID) async {
        do { state = .archived(try await archiveMealUseCase.execute(id: id)) }
        catch { state = .error("Unable to archive this meal.") }
    }

    func duplicate(id: UUID) async -> Meal? {
        do { return try await duplicateMealUseCase.execute(id: id) }
        catch { state = .error("Unable to duplicate this meal."); return nil }
    }

    func delete(id: UUID) async {
        do { try await deleteMealUseCase.execute(id: id); state = .deleted }
        catch { state = .error("Unable to delete this meal.") }
    }
}
