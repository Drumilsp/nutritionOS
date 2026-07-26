//
//  FoodEditorViewModel.swift
//  Nutri
//

import Foundation
import Observation

@MainActor
@Observable
final class FoodEditorViewModel {
    private let createFoodUseCase: CreateFoodUseCase
    private let updateFoodUseCase: UpdateFoodUseCase
    private let validator: FoodValidator
    private let isEditingExistingFoodValue: Bool
    private let editingFoodValue: Food

    private(set) var state: FoodEditorState

    var editingFood: Food { editingFoodValue }

    var isEditingExistingFood: Bool { isEditingExistingFoodValue }

    init(
        food: Food,
        isEditingExistingFood: Bool,
        createFoodUseCase: CreateFoodUseCase,
        updateFoodUseCase: UpdateFoodUseCase,
        validator: FoodValidator? = nil
    ) {
        self.createFoodUseCase = createFoodUseCase
        self.updateFoodUseCase = updateFoodUseCase
        self.validator = validator ?? FoodValidator()
        self.isEditingExistingFoodValue = isEditingExistingFood
        self.editingFoodValue = food
        self.state = .editing(food)
    }

    func save(_ food: Food) async {
        let normalizedFood = validator.normalizedFood(food)
        let validation = validator.validate(normalizedFood)
        guard validation.errors.isEmpty else {
            state = .validationError(validation.errors)
            return
        }

        state = .saving
        do {
            let savedFood = if isEditingExistingFoodValue {
                try await updateFoodUseCase.execute(normalizedFood)
            } else {
                try await createFoodUseCase.execute(normalizedFood)
            }
            state = .saved(savedFood)
        } catch let error as ValidationFailure {
            state = .validationError(error.errors)
        } catch {
            state = .error("Unable to save this food.")
        }
    }
}
