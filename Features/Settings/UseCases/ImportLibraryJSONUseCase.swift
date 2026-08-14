import Foundation

/// Imports a validated personal food and meal library from the documented JSON format.
struct ImportLibraryJSONUseCase {
    private let foodRepository: any FoodRepository
    private let mealRepository: any MealRepository
    private let createFoodUseCase: CreateFoodUseCase
    private let createMealUseCase: CreateMealUseCase

    init(foodRepository: any FoodRepository, mealRepository: any MealRepository) {
        self.foodRepository = foodRepository
        self.mealRepository = mealRepository
        self.createFoodUseCase = CreateFoodUseCase(foodRepository: foodRepository)
        self.createMealUseCase = CreateMealUseCase(mealRepository: mealRepository)
    }

    func execute(json: String) async throws -> LibraryImportResult {
        guard let data = json.data(using: .utf8) else { throw LibraryImportError.invalidJSON }
        let payload: LibraryImportPayload
        do {
            payload = try JSONDecoder().decode(LibraryImportPayload.self, from: data)
        } catch {
            throw LibraryImportError.invalidJSON
        }

        let existingFoods = try await foodRepository.allFoods().filter { !$0.isArchived }
        let existingMeals = try await mealRepository.allMeals().filter { !$0.isArchived }
        try validate(payload: payload, existingFoods: existingFoods)

        var foodsByName = Dictionary(uniqueKeysWithValues: existingFoods.map { (normalizedName($0.name), $0) })
        var importedFoods = 0
        var skippedFoods = 0

        for sourceFood in payload.foods {
            let key = normalizedName(sourceFood.name)
            if foodsByName[key] != nil {
                skippedFoods += 1
                continue
            }
            let food = try await createFoodUseCase.execute(sourceFood.makeFood())
            foodsByName[key] = food
            importedFoods += 1
        }

        var importedMeals = 0
        var skippedMeals = 0
        let existingMealNames = Set(existingMeals.map { normalizedName($0.name) })
        for sourceMeal in payload.meals {
            if existingMealNames.contains(normalizedName(sourceMeal.name)) {
                skippedMeals += 1
                continue
            }
            let mealItems = try sourceMeal.items.map { sourceItem -> MealItem in
                guard let food = foodsByName[normalizedName(sourceItem.foodName)] else {
                    throw LibraryImportError.missingFood(sourceItem.foodName)
                }
                return MealItem(foodReference: food, quantity: sourceItem.quantity, servingUnit: ServingUnit(name: sourceItem.unit))
            }
            _ = try await createMealUseCase.execute(Meal(name: sourceMeal.name, mealItems: mealItems))
            importedMeals += 1
        }

        return LibraryImportResult(
            importedFoods: importedFoods,
            skippedFoods: skippedFoods,
            importedMeals: importedMeals,
            skippedMeals: skippedMeals
        )
    }

    private func validate(payload: LibraryImportPayload, existingFoods: [Food]) throws {
        let foodNames = payload.foods.map { normalizedName($0.name) }
        guard Set(foodNames).count == foodNames.count else { throw LibraryImportError.duplicateFoodName }
        let mealNames = payload.meals.map { normalizedName($0.name) }
        guard Set(mealNames).count == mealNames.count else { throw LibraryImportError.duplicateMealName }

        let availableFoodNames = Set(existingFoods.map { normalizedName($0.name) }).union(foodNames)
        for sourceFood in payload.foods {
            try FoodValidator().validate(sourceFood.makeFood()).throwIfInvalid()
        }
        for sourceMeal in payload.meals {
            guard !normalizedName(sourceMeal.name).isEmpty, !sourceMeal.items.isEmpty else {
                throw LibraryImportError.invalidMeal(sourceMeal.name)
            }
            for sourceItem in sourceMeal.items {
                guard availableFoodNames.contains(normalizedName(sourceItem.foodName)) else {
                    throw LibraryImportError.missingFood(sourceItem.foodName)
                }
                guard sourceItem.quantity.isFinite, sourceItem.quantity > 0,
                      ServingUnit.validNames.contains(sourceItem.unit) else {
                    throw LibraryImportError.invalidMeal(sourceMeal.name)
                }
            }
        }
    }

    private func normalizedName(_ name: String) -> String {
        TextNormalizer.normalizedName(name)
    }
}

struct LibraryImportResult {
    let importedFoods: Int
    let skippedFoods: Int
    let importedMeals: Int
    let skippedMeals: Int

    var localizedDescription: String {
        "Imported \(importedFoods) foods and \(importedMeals) meals. Skipped \(skippedFoods) duplicate foods and \(skippedMeals) duplicate meals."
    }
}

private struct LibraryImportPayload: Decodable {
    let foods: [LibraryImportFood]
    let meals: [LibraryImportMeal]
}

private struct LibraryImportFood: Decodable {
    let name: String
    let servingSize: Double
    let servingUnit: String
    let calories: Double
    let protein: Double
    let carbohydrates: Double
    let fat: Double
    let fiber: Double

    func makeFood() -> Food {
        Food(
            name: name,
            referenceQuantity: servingSize,
            referenceUnit: ServingUnit(name: servingUnit),
            nutritionProfile: NutritionProfile(nutrientValues: [
                NutrientValue(nutrientType: .calories, value: calories, unit: .kilocalories),
                NutrientValue(nutrientType: .protein, value: protein, unit: .grams),
                NutrientValue(nutrientType: .carbohydrates, value: carbohydrates, unit: .grams),
                NutrientValue(nutrientType: .fat, value: fat, unit: .grams),
                NutrientValue(nutrientType: .fibre, value: fiber, unit: .grams)
            ])
        )
    }
}

private struct LibraryImportMeal: Decodable {
    let name: String
    let items: [LibraryImportMealItem]
}

private struct LibraryImportMealItem: Decodable {
    let foodName: String
    let quantity: Double
    let unit: String
}

private enum LibraryImportError: LocalizedError {
    case invalidJSON
    case missingFood(String)
    case invalidMeal(String)
    case duplicateFoodName
    case duplicateMealName

    var errorDescription: String? {
        switch self {
        case .invalidJSON: "The JSON does not match the supported foods and meals format."
        case .missingFood(let name): "Meal references missing food: \(name)."
        case .invalidMeal(let name): "Meal is invalid: \(name)."
        case .duplicateFoodName: "The import contains duplicate food names."
        case .duplicateMealName: "The import contains duplicate meal names."
        }
    }
}
