//
//  SwiftDataFoodRepository.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData-backed implementation of food template persistence.
@MainActor
final class SwiftDataFoodRepository: FoodRepository {

    // MARK: - Properties

    private let persistenceManager: PersistenceManager

    // MARK: - Initialization

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }

    // MARK: - FoodRepository

    func save(_ food: Food) async throws -> Food {
        let context = persistenceManager.mainContext

        do {
            guard try foodEntity(id: food.id) == nil else {
                throw RepositoryError.alreadyExists
            }

            let entity = FoodMapper.toEntity(food)
            context.insert(entity)
            try context.save()
            return FoodMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func food(id: UUID) async throws -> Food {
        guard let entity = try foodEntity(id: id) else {
            throw RepositoryError.notFound
        }

        return FoodMapper.toDomain(entity)
    }

    func allFoods() async throws -> [Food] {
        try foodEntities().map(FoodMapper.toDomain).sorted(by: alphabeticalOrder)
    }

    func searchFoods(query: String) async throws -> [Food] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedQuery.isEmpty else {
            return try await allFoods()
        }

        return try foodEntities()
            .map(FoodMapper.toDomain)
            .filter { !$0.isArchived && matches($0, query: normalizedQuery) }
            .sorted { searchRank($0, query: normalizedQuery) < searchRank($1, query: normalizedQuery) }
    }

    func favoriteFoods() async throws -> [Food] {
        try foodEntities()
            .filter(\.isFavorite)
            .map(FoodMapper.toDomain)
            .filter { !$0.isArchived }
            .sorted(by: alphabeticalOrder)
    }

    func recentlyUsedFoods(limit: Int) async throws -> [Food] {
        try foodEntities()
            .map(FoodMapper.toDomain)
            .filter { !$0.isArchived && $0.lastUsedAt != nil }
            .sorted { ($0.lastUsedAt ?? .distantPast) > ($1.lastUsedAt ?? .distantPast) }
            .prefix(limit)
            .map { $0 }
    }

    func foods(category: String) async throws -> [Food] {
        try foodEntities()
            .filter { $0.category == category }
            .map(FoodMapper.toDomain)
    }

    func update(_ food: Food) async throws -> Food {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try foodEntity(id: food.id) else {
                throw RepositoryError.notFound
            }

            if entity.isSystemFood {
                throw ValidationFailure(errors: [.systemFoodReadOnly])
            }

            FoodMapper.apply(food, to: entity)
            try context.save()
            return FoodMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func archiveFood(id: UUID) async throws -> Food {
        try await setArchived(true, foodID: id)
    }

    func restoreFood(id: UUID) async throws -> Food {
        try await setArchived(false, foodID: id)
    }

    func setFavorite(id: UUID, isFavorite: Bool) async throws -> Food {
        let context = persistenceManager.mainContext
        do {
            guard let entity = try foodEntity(id: id) else { throw RepositoryError.notFound }
            entity.isFavorite = isFavorite
            entity.updatedAt = Date()
            try context.save()
            return FoodMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func markUsed(id: UUID, at date: Date) async throws -> Food {
        let context = persistenceManager.mainContext
        do {
            guard let entity = try foodEntity(id: id) else { throw RepositoryError.notFound }
            entity.lastUsedAt = date
            try context.save()
            return FoodMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func deleteFood(id: UUID) async throws {
        let context = persistenceManager.mainContext
        do {
            guard let entity = try foodEntity(id: id) else { throw RepositoryError.notFound }
            context.delete(entity)
            try context.save()
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func deleteAllFoods() async throws {
        let context = persistenceManager.mainContext
        do {
            try foodEntities().forEach(context.delete)
            try context.save()
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    // MARK: - Private Methods

    private func setArchived(_ isArchived: Bool, foodID: UUID) async throws -> Food {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try foodEntity(id: foodID) else {
                throw RepositoryError.notFound
            }

            if entity.isSystemFood {
                throw ValidationFailure(errors: [.systemFoodReadOnly])
            }

            entity.isArchived = isArchived
            entity.updatedAt = Date()
            try context.save()
            return FoodMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    private func foodEntity(id: UUID) throws -> FoodEntity? {
        try foodEntities().first { $0.id == id }
    }

    private func foodEntities() throws -> [FoodEntity] {
        let descriptor = FetchDescriptor<FoodEntity>()
        return try persistenceManager.mainContext.fetch(descriptor)
    }

    private func matches(_ food: Food, query: String) -> Bool {
        food.name.localizedCaseInsensitiveContains(query)
            || (food.category?.localizedCaseInsensitiveContains(query) ?? false)
    }

    private func searchRank(_ food: Food, query: String) -> (Int, Int, Int, Int, String) {
        let normalizedName = food.name.lowercased()
        let exactRank = normalizedName == query ? 0 : 1
        let favoriteRank = food.isFavorite ? 0 : 1
        let recentRank = food.lastUsedAt == nil ? 1 : 0
        let matchRank = normalizedName.hasPrefix(query) ? 0 : 1
        return (exactRank, favoriteRank, recentRank, matchRank, normalizedName)
    }

    private func alphabeticalOrder(_ first: Food, _ second: Food) -> Bool {
        first.name.localizedCaseInsensitiveCompare(second.name) == .orderedAscending
    }
}
