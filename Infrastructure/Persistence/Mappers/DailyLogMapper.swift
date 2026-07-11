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
            calorieGoalSnapshot: entity.calorieGoalSnapshot,
            proteinGoalSnapshot: entity.proteinGoalSnapshot,
            fatGoalSnapshot: entity.fatGoalSnapshot,
            fibreGoalSnapshot: entity.fibreGoalSnapshot,
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
            foodName: entity.foodName,
            category: entity.category,
            referenceQuantity: entity.referenceQuantity,
            referenceUnit: ServingUnit(name: entity.referenceUnitName),
            loggedQuantity: entity.loggedQuantity,
            nutritionProfileSnapshot: NutritionProfile(
                nutrientValues: entity.nutrientValues.map { FoodMapper.toDomain($0) }
            ),
            mealSlot: MealSlot(rawValue: entity.mealSlotRawValue) ?? .snack,
            createdAt: entity.createdAt,
            notes: entity.notes
        )
    }

    static func toDomain(_ entity: LoggedMealEntity) -> LoggedMeal {
        LoggedMeal(
            id: entity.id,
            mealName: entity.mealName,
            loggedFoods: entity.loggedFoods.map { toDomain($0) },
            mealSlot: MealSlot(rawValue: entity.mealSlotRawValue) ?? .snack,
            createdAt: entity.createdAt,
            notes: entity.notes
        )
    }

    // MARK: - Entity Mapping

    static func toEntity(_ dailyLog: DailyLog) -> DailyLogEntity {
        DailyLogEntity(
            id: dailyLog.id,
            date: dailyLog.date,
            loggedFoods: dailyLog.loggedFoods.map { toEntity($0) },
            loggedMeals: dailyLog.loggedMeals.map { toEntity($0) },
            waterIntake: dailyLog.waterIntake,
            calorieGoalSnapshot: dailyLog.calorieGoalSnapshot,
            proteinGoalSnapshot: dailyLog.proteinGoalSnapshot,
            fatGoalSnapshot: dailyLog.fatGoalSnapshot,
            fibreGoalSnapshot: dailyLog.fibreGoalSnapshot,
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
            foodName: loggedFood.foodName,
            category: loggedFood.category,
            referenceQuantity: loggedFood.referenceQuantity,
            referenceUnitName: loggedFood.referenceUnit.name,
            loggedQuantity: loggedFood.loggedQuantity,
            nutrientValues: loggedFood.nutritionProfileSnapshot.nutrientValues.map { FoodMapper.toEntity($0) },
            mealSlotRawValue: loggedFood.mealSlot.rawValue,
            createdAt: loggedFood.createdAt,
            notes: loggedFood.notes
        )
    }

    static func toEntity(_ loggedMeal: LoggedMeal) -> LoggedMealEntity {
        LoggedMealEntity(
            id: loggedMeal.id,
            mealName: loggedMeal.mealName,
            loggedFoods: loggedMeal.loggedFoods.map { toEntity($0) },
            mealSlotRawValue: loggedMeal.mealSlot.rawValue,
            createdAt: loggedMeal.createdAt,
            notes: loggedMeal.notes
        )
    }

    static func apply(_ dailyLog: DailyLog, to entity: DailyLogEntity) {
        entity.date = dailyLog.date
        entity.loggedFoods = dailyLog.loggedFoods.map { toEntity($0) }
        entity.loggedMeals = dailyLog.loggedMeals.map { toEntity($0) }
        entity.waterIntake = dailyLog.waterIntake
        entity.calorieGoalSnapshot = dailyLog.calorieGoalSnapshot
        entity.proteinGoalSnapshot = dailyLog.proteinGoalSnapshot
        entity.fatGoalSnapshot = dailyLog.fatGoalSnapshot
        entity.fibreGoalSnapshot = dailyLog.fibreGoalSnapshot
        entity.maintenanceCaloriesSnapshot = dailyLog.maintenanceCaloriesSnapshot
        entity.activeCalories = dailyLog.activeCalories
        entity.restingCalories = dailyLog.restingCalories
        entity.notes = dailyLog.notes
        entity.isCompleted = dailyLog.isCompleted
        entity.updatedAt = dailyLog.updatedAt
    }
}
