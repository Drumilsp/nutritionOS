//
//  MealMapper.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Maps meal domain models to and from SwiftData persistence entities.
enum MealMapper {

    // MARK: - Domain Mapping

    static func toDomain(_ entity: MealEntity) throws -> Meal {
        Meal(
            id: entity.id,
            name: entity.name,
            mealItems: try entity.mealItems.map { try toDomain($0) },
            notes: entity.notes,
            isFavorite: entity.isFavorite,
            isArchived: entity.isArchived,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func toDomain(_ entity: MealItemEntity) throws -> MealItem {
        guard let foodReference = entity.foodReference else {
            throw RepositoryError.persistenceFailure
        }

        return MealItem(
            id: entity.id,
            foodReference: FoodMapper.toDomain(foodReference),
            quantity: entity.quantity
        )
    }

    // MARK: - Entity Mapping

    static func toEntity(_ meal: Meal) -> MealEntity {
        MealEntity(
            id: meal.id,
            name: meal.name,
            mealItems: meal.mealItems.map { toEntity($0) },
            notes: meal.notes,
            isFavorite: meal.isFavorite,
            isArchived: meal.isArchived,
            createdAt: meal.createdAt,
            updatedAt: meal.updatedAt
        )
    }

    static func toEntity(_ mealItem: MealItem) -> MealItemEntity {
        MealItemEntity(
            id: mealItem.id,
            foodReference: FoodMapper.toEntity(mealItem.foodReference),
            quantity: mealItem.quantity
        )
    }

    static func apply(_ meal: Meal, to entity: MealEntity) {
        entity.name = meal.name
        entity.mealItems = meal.mealItems.map { toEntity($0) }
        entity.notes = meal.notes
        entity.isFavorite = meal.isFavorite
        entity.isArchived = meal.isArchived
        entity.updatedAt = meal.updatedAt
    }
}
