//
//  MealEditorViewModel.swift
//  Nutri
//

import Foundation
import Observation

@MainActor
@Observable
final class MealEditorViewModel {
    private let createMealUseCase: CreateMealUseCase
    private let updateMealUseCase: UpdateMealUseCase
    private let validator: MealValidator
    private let isEditingExistingMeal: Bool

    private(set) var state: MealEditorState

    init(
        meal: Meal,
        isEditingExistingMeal: Bool,
        createMealUseCase: CreateMealUseCase,
        updateMealUseCase: UpdateMealUseCase,
        validator: MealValidator = MealValidator()
    ) {
        self.createMealUseCase = createMealUseCase
        self.updateMealUseCase = updateMealUseCase
        self.validator = validator
        self.isEditingExistingMeal = isEditingExistingMeal
        self.state = .editing(meal)
    }

    func addFood(_ food: Food, quantity: Double, servingUnit: ServingUnit? = nil) {
        mutateMeal { meal in
            meal.mealItems.append(MealItem(foodReference: food, quantity: quantity, servingUnit: servingUnit))
        }
    }

    func removeFood(itemID: UUID) {
        mutateMeal { meal in meal.mealItems.removeAll { $0.id == itemID } }
    }

    func changeQuantity(itemID: UUID, quantity: Double) {
        mutateMeal { meal in meal.mealItems.first { $0.id == itemID }?.quantity = quantity }
    }

    func reorderFoods(from source: IndexSet, to destination: Int) {
        mutateMeal { meal in
            let movedItems = source.sorted(by: >).map { meal.mealItems.remove(at: $0) }.reversed()
            let adjustedDestination = destination - source.filter { $0 < destination }.count
            meal.mealItems.insert(contentsOf: movedItems, at: adjustedDestination)
        }
    }

    func editNotes(_ notes: String?) {
        mutateMeal { $0.notes = notes }
    }

    func save() async {
        guard case .editing(let meal) = state else { return }
        let normalizedMeal = validator.normalizedMeal(meal)
        let validation = validator.validate(normalizedMeal)
        guard validation.errors.isEmpty else {
            state = .validationError(validation.errors)
            return
        }

        state = .saving
        do {
            let savedMeal = if isEditingExistingMeal {
                try await updateMealUseCase.execute(normalizedMeal)
            } else {
                try await createMealUseCase.execute(normalizedMeal)
            }
            state = .saved(savedMeal)
        } catch let error as ValidationFailure {
            state = .validationError(error.errors)
        } catch {
            state = .error("Unable to save this meal.")
        }
    }

    private func mutateMeal(_ mutation: (Meal) -> Void) {
        guard case .editing(let meal) = state else { return }
        mutation(meal)
        state = .editing(meal)
    }
}
