//
//  NutritionDomainTests.swift
//  NutriTests
//
//  Created by Drumil Patil on 11/07/26.
//

import Testing
import Foundation
@testable import Nutri

struct NutritionDomainTests {

    @MainActor
    @Test func nutritionProfileStoresSparseNutrientValues() {
        let profile = NutritionProfile(
            nutrientValues: [
                NutrientValue(
                    nutrientType: .calories,
                    value: 120,
                    unit: .kilocalories
                )
            ]
        )

        #expect(profile.nutrientValues.count == 1)
        #expect(profile.nutrientValues.first?.nutrientType == .calories)
    }

    @MainActor
    @Test func mealItemReferencesFoodWithoutDuplicatingUnits() {
        let food = makeFood(name: "Chicken", referenceQuantity: 100, referenceUnit: .grams)
        let mealItem = MealItem(foodReference: food, quantity: 2)

        #expect(mealItem.foodReference === food)
        #expect(mealItem.quantity == 2)
        #expect(mealItem.foodReference.referenceUnit == .grams)
    }

    @Test func mealTemplateDoesNotStoreMealSlot() {
        let food = makeFood(name: "Egg", referenceQuantity: 1, referenceUnit: .piece)
        let mealItem = MealItem(foodReference: food, quantity: 2)
        let meal = Meal(name: "Breakfast Plate", mealItems: [mealItem])

        #expect(meal.name == "Breakfast Plate")
        #expect(meal.mealItems.count == 1)
    }

    @Test func loggedFoodSnapshotDoesNotChangeWhenFoodIsEdited() {
        let food = makeFood(name: "Milk", referenceQuantity: 100, referenceUnit: .millilitres)
        let loggedFood = LoggedFood(
            foodName: food.name,
            category: food.category,
            referenceQuantity: food.referenceQuantity,
            referenceUnit: food.referenceUnit,
            loggedQuantity: 1,
            nutritionProfileSnapshot: food.nutritionProfile,
            mealSlot: .snack
        )

        food.name = "Updated Milk"
        food.referenceQuantity = 200
        food.nutritionProfile = NutritionProfile()

        #expect(loggedFood.foodName == "Milk")
        #expect(loggedFood.referenceQuantity == 100)
        #expect(loggedFood.nutritionProfileSnapshot.nutrientValues.count == 1)
    }

    @Test func loggedMealOwnsLoggedFoodSnapshots() {
        let loggedFood = LoggedFood(
            foodName: "Chapati",
            referenceQuantity: 1,
            referenceUnit: ServingUnit(name: "Chapati"),
            loggedQuantity: 2,
            nutritionProfileSnapshot: NutritionProfile(),
            mealSlot: .dinner
        )
        let loggedMeal = LoggedMeal(
            mealName: "Dinner",
            loggedFoods: [loggedFood],
            mealSlot: .dinner
        )

        #expect(loggedMeal.loggedFoods.count == 1)
        #expect(loggedMeal.loggedFoods.first?.foodName == "Chapati")
        #expect(loggedMeal.mealSlot == .dinner)
    }

    @Test func dailyLogStoresImmutableGoalSnapshots() {
        let dailyLog = DailyLog(
            date: Date(),
            waterIntake: 500,
            calorieGoalSnapshot: 2_200,
            proteinGoalSnapshot: 150,
            fatGoalSnapshot: 70,
            fibreGoalSnapshot: 30,
            maintenanceCaloriesSnapshot: 2_700
        )

        dailyLog.waterIntake = 750

        #expect(dailyLog.waterIntake == 750)
        #expect(dailyLog.calorieGoalSnapshot == 2_200)
        #expect(dailyLog.proteinGoalSnapshot == 150)
        #expect(dailyLog.isCompleted == false)
    }

    // MARK: - Helpers

    private func makeFood(
        name: String,
        referenceQuantity: Double,
        referenceUnit: ServingUnit
    ) -> Food {
        Food(
            name: name,
            category: "Protein",
            referenceQuantity: referenceQuantity,
            referenceUnit: referenceUnit,
            nutritionProfile: NutritionProfile(
                nutrientValues: [
                    NutrientValue(
                        nutrientType: .protein,
                        value: 10,
                        unit: .grams
                    )
                ]
            )
        )
    }
}
