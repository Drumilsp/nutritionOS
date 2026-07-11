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
        try mealEntities().map(MealMapper.toDomain)
    }

    func searchMeals(query: String) async throws -> [Meal] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedQuery.isEmpty else {
            return try await allMeals()
        }

        return try mealEntities()
            .filter { $0.name.localizedCaseInsensitiveContains(normalizedQuery) }
            .map(MealMapper.toDomain)
    }

    func favoriteMeals() async throws -> [Meal] {
        try mealEntities()
            .filter(\.isFavorite)
            .map(MealMapper.toDomain)
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
            quantity: mealItem.quantity
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
}
