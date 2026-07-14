//
//  SwiftDataMealRepository.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation
import SwiftData

/// SwiftData-backed implementation of meal template persistence.
@MainActor
final class SwiftDataMealRepository: MealRepository {

    // MARK: - Properties

    private let persistenceManager: PersistenceManager

    // MARK: - Initialization

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }

    // MARK: - MealRepository

    func save(_ meal: Meal) async throws -> Meal {
        let context = persistenceManager.mainContext

        do {
            guard try mealEntity(id: meal.id) == nil else {
                throw RepositoryError.alreadyExists
            }

            let entity = try makeMealEntity(from: meal)
            context.insert(entity)
            try context.save()
            return try MealMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func meal(id: UUID) async throws -> Meal {
        guard let entity = try mealEntity(id: id) else {
            throw RepositoryError.notFound
        }

        return try MealMapper.toDomain(entity)
    }

    func allMeals() async throws -> [Meal] {
        try mealEntities().map(MealMapper.toDomain).sorted(by: alphabeticalOrder)
    }

    func searchMeals(query: String) async throws -> [Meal] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedQuery.isEmpty else {
            return try await allMeals()
        }

        return try mealEntities()
            .map(MealMapper.toDomain)
            .filter { !$0.isArchived && matches($0, query: normalizedQuery) }
            .sorted { searchRank($0, query: normalizedQuery) < searchRank($1, query: normalizedQuery) }
    }

    func favoriteMeals() async throws -> [Meal] {
        try mealEntities()
            .filter(\.isFavorite)
            .map(MealMapper.toDomain)
            .filter { !$0.isArchived }
            .sorted(by: alphabeticalOrder)
    }

    func recentlyUsedMeals(limit: Int) async throws -> [Meal] {
        try mealEntities()
            .map(MealMapper.toDomain)
            .filter { !$0.isArchived && $0.lastUsedAt != nil }
            .sorted { ($0.lastUsedAt ?? .distantPast) > ($1.lastUsedAt ?? .distantPast) }
            .prefix(limit)
            .map { $0 }
    }

    func update(_ meal: Meal) async throws -> Meal {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try mealEntity(id: meal.id) else {
                throw RepositoryError.notFound
            }

            entity.name = meal.name
            entity.mealItems = try meal.mealItems.map(makeMealItemEntity)
            entity.notes = meal.notes
            entity.isFavorite = meal.isFavorite
            entity.isArchived = meal.isArchived
            entity.updatedAt = meal.updatedAt

            try context.save()
            return try MealMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func archiveMeal(id: UUID) async throws -> Meal {
        try await setArchived(true, mealID: id)
    }

    func restoreMeal(id: UUID) async throws -> Meal {
        try await setArchived(false, mealID: id)
    }

    func setFavorite(id: UUID, isFavorite: Bool) async throws -> Meal {
        let context = persistenceManager.mainContext
        do {
            guard let entity = try mealEntity(id: id) else { throw RepositoryError.notFound }
            entity.isFavorite = isFavorite
            entity.updatedAt = Date()
            try context.save()
            return try MealMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func markUsed(id: UUID, at date: Date) async throws -> Meal {
        let context = persistenceManager.mainContext
        do {
            guard let entity = try mealEntity(id: id) else { throw RepositoryError.notFound }
            entity.lastUsedAt = date
            try context.save()
            return try MealMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    func deleteMeal(id: UUID) async throws {
        let context = persistenceManager.mainContext
        do {
            guard let entity = try mealEntity(id: id) else { throw RepositoryError.notFound }
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

    // MARK: - Private Methods

    private func setArchived(_ isArchived: Bool, mealID: UUID) async throws -> Meal {
        let context = persistenceManager.mainContext

        do {
            guard let entity = try mealEntity(id: mealID) else {
                throw RepositoryError.notFound
            }

            entity.isArchived = isArchived
            entity.updatedAt = Date()
            try context.save()
            return try MealMapper.toDomain(entity)
        } catch let error as RepositoryError {
            context.rollback()
            throw error
        } catch {
            context.rollback()
            throw RepositoryError.persistenceFailure
        }
    }

    private func makeMealEntity(from meal: Meal) throws -> MealEntity {
        MealEntity(
            id: meal.id,
            name: meal.name,
            mealItems: try meal.mealItems.map(makeMealItemEntity),
            notes: meal.notes,
            isFavorite: meal.isFavorite,
            isArchived: meal.isArchived,
            lastUsedAt: meal.lastUsedAt,
            createdAt: meal.createdAt,
            updatedAt: meal.updatedAt
        )
    }

    private func makeMealItemEntity(from mealItem: MealItem) throws -> MealItemEntity {
        guard let foodEntity = try foodEntity(id: mealItem.foodReference.id) else {
            throw RepositoryError.notFound
        }

        return MealItemEntity(
            id: mealItem.id,
            foodReference: foodEntity,
            quantity: mealItem.quantity,
            servingUnitName: mealItem.servingUnit.name
        )
    }

    private func foodEntity(id: UUID) throws -> FoodEntity? {
        let descriptor = FetchDescriptor<FoodEntity>()
        return try persistenceManager.mainContext.fetch(descriptor).first { $0.id == id }
    }

    private func mealEntity(id: UUID) throws -> MealEntity? {
        try mealEntities().first { $0.id == id }
    }

    private func mealEntities() throws -> [MealEntity] {
        let descriptor = FetchDescriptor<MealEntity>()
        return try persistenceManager.mainContext.fetch(descriptor)
    }

    private func matches(_ meal: Meal, query: String) -> Bool {
        meal.name.localizedCaseInsensitiveContains(query)
            || meal.mealItems.contains { $0.foodReference.name.localizedCaseInsensitiveContains(query) }
    }

    private func searchRank(_ meal: Meal, query: String) -> (Int, Int, Int, Int, String) {
        let normalizedName = meal.name.lowercased()
        return (
            normalizedName == query ? 0 : 1,
            meal.isFavorite ? 0 : 1,
            meal.lastUsedAt == nil ? 1 : 0,
            normalizedName.hasPrefix(query) ? 0 : 1,
            normalizedName
        )
    }

    private func alphabeticalOrder(_ first: Meal, _ second: Meal) -> Bool {
        first.name.localizedCaseInsensitiveCompare(second.name) == .orderedAscending
    }
}
