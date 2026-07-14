//
//  FoodMapper.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Maps food domain models to and from SwiftData persistence entities.
enum FoodMapper {

    // MARK: - Domain Mapping

    static func toDomain(_ entity: FoodEntity) -> Food {
        Food(
            id: entity.id,
            name: entity.name,
            category: entity.category,
            referenceQuantity: entity.referenceQuantity,
            referenceUnit: ServingUnit(name: entity.referenceUnitName),
            nutritionProfile: NutritionProfile(
                nutrientValues: entity.nutrientValues.map { toDomain($0) }
            ),
            notes: entity.notes,
            isSystemFood: entity.isSystemFood,
            isFavorite: entity.isFavorite,
            isArchived: entity.isArchived,
            lastUsedAt: entity.lastUsedAt,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func toDomain(_ entity: NutrientValueEntity) -> NutrientValue {
        NutrientValue(
            id: entity.id,
            nutrientType: NutrientType(
                id: entity.nutrientTypeID,
                name: entity.nutrientTypeName
            ),
            value: entity.value,
            unit: NutritionUnit(symbol: entity.unitSymbol)
        )
    }

    // MARK: - Entity Mapping

    static func toEntity(_ food: Food) -> FoodEntity {
        FoodEntity(
            id: food.id,
            name: food.name,
            category: food.category,
            referenceQuantity: food.referenceQuantity,
            referenceUnitName: food.referenceUnit.name,
            nutrientValues: food.nutritionProfile.nutrientValues.map { toEntity($0) },
            notes: food.notes,
            isSystemFood: food.isSystemFood,
            isFavorite: food.isFavorite,
            isArchived: food.isArchived,
            lastUsedAt: food.lastUsedAt,
            createdAt: food.createdAt,
            updatedAt: food.updatedAt
        )
    }

    static func toEntity(_ nutrientValue: NutrientValue) -> NutrientValueEntity {
        NutrientValueEntity(
            id: nutrientValue.id,
            nutrientTypeID: nutrientValue.nutrientType.id,
            nutrientTypeName: nutrientValue.nutrientType.name,
            value: nutrientValue.value,
            unitSymbol: nutrientValue.unit.symbol
        )
    }

    static func apply(_ food: Food, to entity: FoodEntity) {
        entity.name = food.name
        entity.category = food.category
        entity.referenceQuantity = food.referenceQuantity
        entity.referenceUnitName = food.referenceUnit.name
        entity.nutrientValues = food.nutritionProfile.nutrientValues.map { toEntity($0) }
        entity.notes = food.notes
        entity.isSystemFood = food.isSystemFood
        entity.isFavorite = food.isFavorite
        entity.isArchived = food.isArchived
        entity.lastUsedAt = food.lastUsedAt
        entity.updatedAt = food.updatedAt
    }
}
