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
        try foodEntities().map(FoodMapper.toDomain)
    }

    func searchFoods(query: String) async throws -> [Food] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedQuery.isEmpty else {
            return try await allFoods()
        }

        return try foodEntities()
            .filter { $0.name.localizedCaseInsensitiveContains(normalizedQuery) }
            .map(FoodMapper.toDomain)
    }

    func favoriteFoods() async throws -> [Food] {
        try foodEntities()
            .filter(\.isFavorite)
            .map(FoodMapper.toDomain)
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

    // MARK: - Private Methods

    private func setArchived(_ isArchived: Bool, foodID: UUID) async throws -> Food {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try foodEntity(id: foodID) else {
                throw RepositoryError.notFound
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
}
