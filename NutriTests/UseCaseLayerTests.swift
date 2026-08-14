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

    @MainActor
    @Test func mealEditorRetainsItsDraftAfterValidationAndAddsSelectedFood() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let food = try await dependencies.foodRepository.save(makeFood(name: "Oats", calories: 100))
        let editor = dependencies.makeMealEditorViewModel(
            meal: Meal(name: "", mealItems: []),
            isEditingExistingMeal: false
        )

        await editor.save()

        guard case .validationError(let errors) = editor.state else {
            Issue.record("Expected an invalid empty meal to show validation errors.")
            return
        }
        #expect(errors == [.emptyName, .mealHasNoItems])

        editor.updateName("Oats Bowl")
        editor.addFood(food, quantity: food.referenceQuantity)

        #expect(editor.editingMeal.mealItems.count == 1)
        #expect(editor.editingMeal.nutritionProfile().value(for: .calories) == 100)
        guard case .editing = editor.state else {
            Issue.record("Editing a meal after validation should return to the editable state.")
            return
        }
    }

    @MainActor
    @Test func libraryJSONImportCreatesFoodsBeforeReferencedMealsAndSkipsDuplicates() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let useCase = ImportLibraryJSONUseCase(
            foodRepository: dependencies.foodRepository,
            mealRepository: dependencies.mealRepository
        )
        let json = #"""
        {
          "foods": [{
            "name": "Chicken Breast", "servingSize": 100, "servingUnit": "g",
            "calories": 165, "protein": 31, "carbohydrates": 0, "fat": 3.6, "fiber": 0
          }],
          "meals": [{
            "name": "High Protein Lunch",
            "items": [{ "foodName": "Chicken Breast", "quantity": 200, "unit": "g" }]
          }]
        }
        """#

        let firstImport = try await useCase.execute(json: json)
        let secondImport = try await useCase.execute(json: json)
        let meals = try await dependencies.mealRepository.allMeals()

        #expect(firstImport.importedFoods == 1)
        #expect(firstImport.importedMeals == 1)
        #expect(secondImport.skippedFoods == 1)
        #expect(secondImport.skippedMeals == 1)
        #expect(meals.first?.mealItems.count == 1)
    }

    @Test func dailyLogValidatorRejectsInvalidHistoryRange() throws {
        let validator = DailyLogValidator()
        let startDate = Date(timeIntervalSince1970: 20)
        let endDate = Date(timeIntervalSince1970: 10)

        #expect(validator.validateDateRange(from: startDate, to: endDate).errors == [.invalidDateRange])
    }

    @MainActor
    @Test func progressHistoryStatusRequiresRealBalanceAndConfiguredRange() {
        #expect(
            ProgressHistoryDayStatus.classify(
                energyBalance: -400,
                targetRange: -700 ... -300
            ) == .onTarget
        )
        #expect(
            ProgressHistoryDayStatus.classify(
                energyBalance: -800,
                targetRange: -700 ... -300
            ) == .offTarget
        )
        #expect(
            ProgressHistoryDayStatus.classify(
                energyBalance: -400,
                targetRange: nil
            ) == .neutral
        )
        #expect(
            ProgressHistoryDayStatus.classify(
                energyBalance: nil,
                targetRange: -700 ... -300
            ) == .neutral
        )
    }

    @MainActor
    @Test func signedEnergyBalanceRangesSaveAndClearWithoutChangingMacroValidation() async throws {
        let dependencies = AppDependencies(persistenceConfiguration: .testing)
        let useCase = UpdateGoalSettingsUseCase(
            settingsRepository: dependencies.settingsRepository,
            dateProvider: FixedDateProvider(now: Date(timeIntervalSince1970: 400))
        )
        let validRanges: [(Double?, Double?)] = [
            (-700, -300),
            (-150, 150),
            (200, 500),
            (nil, nil)
        ]

        for (lowerBound, upperBound) in validRanges {
            let saved = try await useCase.execute(
                makeGoalSettings(
                    lowerBound: lowerBound,
                    upperBound: upperBound
                )
            )

            #expect(saved.energyBalanceLowerBound == lowerBound)
            #expect(saved.energyBalanceUpperBound == upperBound)
        }

        let persisted = try await dependencies.settingsRepository.goalSettings()
        #expect(persisted.energyBalanceLowerBound == nil)
        #expect(persisted.energyBalanceUpperBound == nil)
    }

    @Test func energyBalanceRangeValidatorRejectsIncompleteAndReversedRangesOnly() {
        let validator = GoalSettingsValidator()

        #expect(validator.validate(makeGoalSettings(lowerBound: -700, upperBound: -300)).errors.isEmpty)
        #expect(validator.validate(makeGoalSettings(lowerBound: nil, upperBound: nil)).errors.isEmpty)
        #expect(validator.validate(makeGoalSettings(lowerBound: -700, upperBound: nil)).errors == [.invalidGoal])
        #expect(validator.validate(makeGoalSettings(lowerBound: nil, upperBound: 150)).errors == [.invalidGoal])
        #expect(validator.validate(makeGoalSettings(lowerBound: 500, upperBound: 200)).errors == [.invalidGoal])
    }

    @MainActor
    @Test func energyBalanceRangeInputShowsSpecificValidationMessages() {
        #expect(
            EnergyBalanceRangeInputValidator.validationMessage(lowerText: "-700", upperText: "")
                == "Enter both lower and upper bounds, or leave both empty."
        )
        #expect(
            EnergyBalanceRangeInputValidator.validationMessage(lowerText: "", upperText: "150")
                == "Enter both lower and upper bounds, or leave both empty."
        )
        #expect(
            EnergyBalanceRangeInputValidator.validationMessage(lowerText: "500", upperText: "200")
                == "Lower bound must be less than or equal to upper bound."
        )
        #expect(
            EnergyBalanceRangeInputValidator.validationMessage(lowerText: "abc", upperText: "150")
                == "Enter valid kcal values."
        )
        #expect(EnergyBalanceRangeInputValidator.validationMessage(lowerText: "", upperText: "") == nil)
    }

    // MARK: - Helpers

    private func makeGoalSettings(lowerBound: Double?, upperBound: Double?) -> GoalSettings {
        GoalSettings(
            goalType: .maintainWeight,
            energyBalanceTarget: .maintain,
            energyBalanceLowerBound: lowerBound,
            energyBalanceUpperBound: upperBound,
            goalCalculationMode: .automatic,
            activityLevel: .lightlyActive,
            dailyProteinGoal: 120,
            dailyCarbohydrateGoal: 250,
            dailyFatGoal: 70,
            dailyWaterGoal: 3_000,
            goalCalculationVersion: 1
        )
    }

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
