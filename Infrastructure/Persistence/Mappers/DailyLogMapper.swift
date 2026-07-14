//
//  DailyLogMapper.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Maps daily log domain models to and from SwiftData persistence entities.
enum DailyLogMapper {

    // MARK: - Domain Mapping

    static func toDomain(_ entity: DailyLogEntity) -> DailyLog {
        DailyLog(
            id: entity.id,
            date: entity.date,
            loggedFoods: entity.loggedFoods.map { toDomain($0) },
            loggedMeals: entity.loggedMeals.map { toDomain($0) },
            waterIntake: entity.waterIntake,
            waterEntries: entity.waterEntries.map(toDomain),
            calorieGoalSnapshot: entity.calorieGoalSnapshot,
            proteinGoalSnapshot: entity.proteinGoalSnapshot,
            carbohydrateGoalSnapshot: entity.carbohydrateGoalSnapshot,
            fatGoalSnapshot: entity.fatGoalSnapshot,
            fibreGoalSnapshot: entity.fibreGoalSnapshot,
            waterGoalSnapshot: entity.waterGoalSnapshot,
            maintenanceCaloriesSnapshot: entity.maintenanceCaloriesSnapshot,
            activeCalories: entity.activeCalories,
            restingCalories: entity.restingCalories,
            notes: entity.notes,
            isCompleted: entity.isCompleted,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func toDomain(_ entity: LoggedFoodEntity) -> LoggedFood {
        LoggedFood(
            id: entity.id,
            foodID: entity.foodID,
            foodName: entity.foodName,
            category: entity.category,
            referenceQuantity: entity.referenceQuantity,
            referenceUnit: ServingUnit(name: entity.referenceUnitName),
            loggedQuantity: entity.loggedQuantity,
            nutritionProfileSnapshot: NutritionProfile(
                nutrientValues: entity.nutrientValues.map { FoodMapper.toDomain($0) }
            ),
            mealSlot: MealSlot(rawValue: entity.mealSlotRawValue),
            createdAt: entity.createdAt,
            source: LoggedEntrySource(rawValue: entity.sourceRawValue) ?? .manualFood,
            notes: entity.notes
        )
    }

    static func toDomain(_ entity: LoggedMealEntity) -> LoggedMeal {
        LoggedMeal(
            id: entity.id,
            mealID: entity.mealID,
            mealName: entity.mealName,
            loggedFoods: entity.loggedFoods.map { toDomain($0) },
            mealSlot: MealSlot(rawValue: entity.mealSlotRawValue),
            createdAt: entity.createdAt,
            source: LoggedEntrySource(rawValue: entity.sourceRawValue) ?? .mealTemplate,
            notes: entity.notes
        )
    }

    static func toDomain(_ entity: WaterEntryEntity) -> WaterEntry { WaterEntry(id: entity.id, amount: entity.amount, timestamp: entity.timestamp) }

    // MARK: - Entity Mapping

    static func toEntity(_ dailyLog: DailyLog) -> DailyLogEntity {
        DailyLogEntity(
            id: dailyLog.id,
            date: dailyLog.date,
            loggedFoods: dailyLog.loggedFoods.map { toEntity($0) },
            loggedMeals: dailyLog.loggedMeals.map { toEntity($0) },
            waterEntries: dailyLog.waterEntries.map(toEntity),
            waterIntake: dailyLog.waterIntake,
            calorieGoalSnapshot: dailyLog.calorieGoalSnapshot,
            proteinGoalSnapshot: dailyLog.proteinGoalSnapshot,
            carbohydrateGoalSnapshot: dailyLog.carbohydrateGoalSnapshot,
            fatGoalSnapshot: dailyLog.fatGoalSnapshot,
            fibreGoalSnapshot: dailyLog.fibreGoalSnapshot,
            waterGoalSnapshot: dailyLog.waterGoalSnapshot,
            maintenanceCaloriesSnapshot: dailyLog.maintenanceCaloriesSnapshot,
            activeCalories: dailyLog.activeCalories,
            restingCalories: dailyLog.restingCalories,
            notes: dailyLog.notes,
            isCompleted: dailyLog.isCompleted,
            createdAt: dailyLog.createdAt,
            updatedAt: dailyLog.updatedAt
        )
    }

    static func toEntity(_ loggedFood: LoggedFood) -> LoggedFoodEntity {
        LoggedFoodEntity(
            id: loggedFood.id,
            foodID: loggedFood.foodID,
            foodName: loggedFood.foodName,
            category: loggedFood.category,
            referenceQuantity: loggedFood.referenceQuantity,
            referenceUnitName: loggedFood.referenceUnit.name,
            loggedQuantity: loggedFood.loggedQuantity,
            nutrientValues: loggedFood.nutritionProfileSnapshot.nutrientValues.map { FoodMapper.toEntity($0) },
            mealSlotRawValue: loggedFood.mealSlot?.rawValue ?? "",
            sourceRawValue: loggedFood.source.rawValue,
            createdAt: loggedFood.createdAt,
            notes: loggedFood.notes
        )
    }

    static func toEntity(_ loggedMeal: LoggedMeal) -> LoggedMealEntity {
        LoggedMealEntity(
            id: loggedMeal.id,
            mealID: loggedMeal.mealID,
            mealName: loggedMeal.mealName,
            loggedFoods: loggedMeal.loggedFoods.map { toEntity($0) },
            mealSlotRawValue: loggedMeal.mealSlot?.rawValue ?? "",
            sourceRawValue: loggedMeal.source.rawValue,
            createdAt: loggedMeal.createdAt,
            notes: loggedMeal.notes
        )
    }

    static func toEntity(_ waterEntry: WaterEntry) -> WaterEntryEntity { WaterEntryEntity(id: waterEntry.id, amount: waterEntry.amount, timestamp: waterEntry.timestamp) }

    static func apply(_ dailyLog: DailyLog, to entity: DailyLogEntity) {
        entity.date = dailyLog.date
        entity.loggedFoods = dailyLog.loggedFoods.map { toEntity($0) }
        entity.loggedMeals = dailyLog.loggedMeals.map { toEntity($0) }
        entity.waterEntries = dailyLog.waterEntries.map(toEntity)
        entity.waterIntake = dailyLog.waterIntake
        entity.calorieGoalSnapshot = dailyLog.calorieGoalSnapshot
        entity.proteinGoalSnapshot = dailyLog.proteinGoalSnapshot
        entity.carbohydrateGoalSnapshot = dailyLog.carbohydrateGoalSnapshot
        entity.fatGoalSnapshot = dailyLog.fatGoalSnapshot
        entity.fibreGoalSnapshot = dailyLog.fibreGoalSnapshot
        entity.waterGoalSnapshot = dailyLog.waterGoalSnapshot
        entity.maintenanceCaloriesSnapshot = dailyLog.maintenanceCaloriesSnapshot
        entity.activeCalories = dailyLog.activeCalories
        entity.restingCalories = dailyLog.restingCalories
        entity.notes = dailyLog.notes
        entity.isCompleted = dailyLog.isCompleted
        entity.updatedAt = dailyLog.updatedAt
    }
}
