//
//  UseCaseLayerTests.swift
//  NutriTests
//
//  Created by Codex on 12/07/26.
//

import Foundation
import Testing
@testable import Nutri

struct UseCaseLayerTests {

    @Test func foodValidatorNormalizesSafeTextAndRejectsInvalidNutrition() throws {
        let validator = FoodValidator()
        let food = Food(
            name: "  chicken   breast ",
            category: "  lean   protein ",
            referenceQuantity: 100,
            referenceUnit: .grams,
            nutritionProfile: NutritionProfile(
                nutrientValues: [
                    NutrientValue(
                        nutrientType: .protein,
                        value: -1,
                        unit: .grams
                    )
                ]
            ),
            notes: "  meal   prep "
        )

        let normalizedFood = validator.normalizedFood(food)
        let result = validator.validate(normalizedFood)

        #expect(normalizedFood.name == "Chicken Breast")
        #expect(normalizedFood.category == "lean protein")
        #expect(normalizedFood.notes == "meal prep")
        #expect(result.errors == [.invalidNutrition])
    }

    @Test func fixedProvidersMakeBusinessLogicDeterministic() {
        let date = Date(timeIntervalSince1970: 10)
        let id = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let dateProvider = FixedDateProvider(now: date)
        let uuidProvider = FixedUUIDProvider(ids: [id])

        #expect(dateProvider.now == date)
        #expect(uuidProvider.makeUUID() == id)
    }

    @MainActor
    @Test func createFoodUseCaseNormalizesAndRejectsDuplicateActiveFood() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let useCase = CreateFoodUseCase(
            foodRepository: dependencies.foodRepository,
            dateProvider: FixedDateProvider(now: Date(timeIntervalSince1970: 100)),
            uuidProvider: FixedUUIDProvider(
                ids: [
                    UUID(uuidString: "00000000-0000-0000-0000-000000000101")!,
                    UUID(uuidString: "00000000-0000-0000-0000-000000000102")!
                ]
            )
        )

        let savedFood = try await useCase.execute(makeFood(name: "  paneer   cubes "))

        #expect(savedFood.name == "Paneer Cubes")
        #expect(savedFood.isArchived == false)

        do {
            _ = try await useCase.execute(makeFood(name: "paneer cubes"))
            Issue.record("Expected duplicate food validation to fail.")
        } catch let failure as ValidationFailure {
            #expect(failure.errors == [.duplicateFood])
        }
    }

    @MainActor
    @Test func logFoodUseCaseCreatesImmutableSnapshotForDashboardSummary() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let date = Date(timeIntervalSince1970: 200)
        let food = try await dependencies.foodRepository.save(makeFood(name: "Rice", calories: 130, protein: 2.5))
        let logUseCase = LogFoodUseCase(
            foodRepository: dependencies.foodRepository,
            dailyLogRepository: dependencies.dailyLogRepository,
            dateProvider: FixedDateProvider(now: date),
            uuidProvider: FixedUUIDProvider(ids: [UUID(uuidString: "00000000-0000-0000-0000-000000000201")!])
        )

        let dailyLog = try await logUseCase.execute(
            foodID: food.id,
            quantity: 200,
            mealSlot: .lunch
        )
        food.nutritionProfile = NutritionProfile()
        let summary = try await GetDashboardSummaryUseCase(
            dailyLogRepository: dependencies.dailyLogRepository,
            dateProvider: FixedDateProvider(now: date)
        ).execute()

        #expect(dailyLog.loggedFoods.count == 1)
        #expect(dailyLog.loggedFoods.first?.foodName == "Rice")
        #expect(summary.caloriesConsumed == 260)
        #expect(summary.proteinConsumed == 5)
    }

    @MainActor
    @Test func mealUseCasesDuplicateAndSearchMealTemplates() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let food = try await dependencies.foodRepository.save(makeFood(name: "Egg", calories: 70, protein: 6))
        let meal = try await dependencies.mealRepository.save(
            Meal(
                name: "Breakfast Plate",
                mealItems: [MealItem(foodReference: food, quantity: 2)]
            )
        )
        let duplicateUseCase = DuplicateMealUseCase(
            mealRepository: dependencies.mealRepository,
            dateProvider: FixedDateProvider(now: Date(timeIntervalSince1970: 300)),
            uuidProvider: FixedUUIDProvider(
                ids: [
                    UUID(uuidString: "00000000-0000-0000-0000-000000000301")!,
                    UUID(uuidString: "00000000-0000-0000-0000-000000000302")!
                ]
            )
        )

        let duplicatedMeal = try await duplicateUseCase.execute(id: meal.id)
        let searchResults = try await SearchMealsUseCase(
            mealRepository: dependencies.mealRepository
        ).execute(query: "egg")

        #expect(duplicatedMeal.name == "Breakfast Plate Copy")
        #expect(duplicatedMeal.mealItems.first?.foodReference === food)
        #expect(searchResults.count == 2)
    }

    @MainActor
    @Test func mealRepositorySearchesRanksFavoritesAndTracksRecentUsage() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let food = try await dependencies.foodRepository.save(makeFood(name: "Rice"))
        let favoriteMeal = try await dependencies.mealRepository.save(
            Meal(name: "Rice Bowl", mealItems: [MealItem(foodReference: food, quantity: 100)], isFavorite: true)
        )
        let exactMeal = try await dependencies.mealRepository.save(
            Meal(name: "Rice", mealItems: [MealItem(foodReference: food, quantity: 100)])
        )

        _ = try await dependencies.mealRepository.markUsed(id: favoriteMeal.id, at: Date())
        let results = try await dependencies.mealRepository.searchMeals(query: "rice")
        let recentlyUsed = try await dependencies.mealRepository.recentlyUsedMeals(limit: 20)

        #expect(results.first?.id == exactMeal.id)
        #expect(recentlyUsed.first?.id == favoriteMeal.id)
    }

    @MainActor
    @Test func mealValidationAndCalculationUseReferencedFoodNutrition() async throws {
        let food = makeFood(name: "Oats", calories: 100, protein: 5)
        let meal = Meal(name: "Oats Bowl", mealItems: [MealItem(foodReference: food, quantity: 200)])
        let invalidMeal = Meal(name: "", mealItems: [])

        #expect(MealValidator().validate(invalidMeal).errors == [.emptyName, .mealHasNoItems])
        #expect(meal.nutritionProfile().value(for: .calories) == 200)
        #expect(meal.nutritionProfile().value(for: .protein) == 10)
    }

    @Test func dailyLogValidatorRejectsInvalidHistoryRange() throws {
        let validator = DailyLogValidator()
        let startDate = Date(timeIntervalSince1970: 20)
        let endDate = Date(timeIntervalSince1970: 10)

        #expect(validator.validateDateRange(from: startDate, to: endDate).errors == [.invalidDateRange])
    }

    // MARK: - Helpers

    private func makeFood(
        name: String,
        calories: Double = 100,
        protein: Double = 10
    ) -> Food {
        Food(
            name: name,
            referenceQuantity: 100,
            referenceUnit: .grams,
            nutritionProfile: NutritionProfile(
                nutrientValues: [
                    NutrientValue(
                        nutrientType: .calories,
                        value: calories,
                        unit: .kilocalories
                    ),
                    NutrientValue(
                        nutrientType: .protein,
                        value: protein,
                        unit: .grams
                    )
                ]
            )
        )
    }
}

private struct FixedDateProvider: DateProvider {
    let now: Date
}

private final class FixedUUIDProvider: UUIDProvider {

    // MARK: - Properties

    private var ids: [UUID]

    // MARK: - Initialization

    init(ids: [UUID]) {
        self.ids = ids
    }

    // MARK: - Public Methods

    func makeUUID() -> UUID {
        ids.removeFirst()
    }
}
