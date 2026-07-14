//
//  RepositoryLayerTests.swift
//  NutriTests
//
//  Created by Drumil Patil on 11/07/26.
//

import Testing
@testable import Nutri

struct RepositoryLayerTests {

    @MainActor
    @Test func foodRepositorySavesAndArchivesFood() async throws {
        let dependencies = AppDependencies(
            persistenceConfiguration: .testing
        )
        let repository = dependencies.foodRepository
        let food = makeFood(name: "Paneer")

        let savedFood = try await repository.save(food)
        let archivedFood = try await repository.archiveFood(id: savedFood.id)

        #expect(savedFood.name == "Paneer")
        #expect(archivedFood.isArchived == true)
    }

    @MainActor
    @Test func dailyLogRepositoryCreatesTodayLogAndUpdatesWater() async throws {
        let dependencies = AppDependencies(
            persistenceConfiguration: .testing
        )
        let repository = dependencies.dailyLogRepository

        let todayLog = try await repository.todayLog()
        let updatedLog = try await repository.updateWaterIntake(
            750,
            on: todayLog.date
        )

        #expect(todayLog.loggedFoods.isEmpty)
        #expect(updatedLog.waterIntake == 750)
        #expect(try await repository.exists(date: todayLog.date))
    }

    @MainActor
    @Test func mealRepositoryPersistsMealTemplateWithFoodReference() async throws {
        let dependencies = AppDependencies(
            persistenceConfiguration: .testing
        )
        let food = try await dependencies.foodRepository.save(
            makeFood(name: "Rice")
        )
        let mealItem = MealItem(
            foodReference: food,
            quantity: 2
        )
        let meal = Meal(
            name: "Rice Bowl",
            mealItems: [mealItem]
        )

        let savedMeal = try await dependencies.mealRepository.save(meal)

        #expect(savedMeal.name == "Rice Bowl")
        #expect(savedMeal.mealItems.first?.foodReference.name == "Rice")
    }

    @MainActor
    @Test func weightRepositorySavesReadsAndDeletesMeasurements() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let entry = try await dependencies.weightRepository.save(
            WeightEntry(weight: 72.4, recordedAt: Date())
        )

        let savedEntries = try await dependencies.weightRepository.entries(
            from: nil,
            to: nil
        )
        try await dependencies.weightRepository.delete(id: entry.id)
        let remainingEntries = try await dependencies.weightRepository.entries(
            from: nil,
            to: nil
        )

        #expect(savedEntries == [entry])
        #expect(remainingEntries.isEmpty)
    }

    // MARK: - Helpers

    private func makeFood(name: String) -> Food {
        Food(
            name: name,
            referenceQuantity: 100,
            referenceUnit: .grams,
            nutritionProfile: NutritionProfile(
                nutrientValues: [
                    NutrientValue(
                        nutrientType: .calories,
                        value: 100,
                        unit: .kilocalories
                    )
                ]
            )
        )
    }
}
