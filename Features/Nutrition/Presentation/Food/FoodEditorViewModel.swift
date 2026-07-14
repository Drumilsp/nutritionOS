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
    private let isEditingExistingFood: Bool

    private(set) var state: FoodEditorState

    init(
        food: Food,
        isEditingExistingFood: Bool,
        createFoodUseCase: CreateFoodUseCase,
        updateFoodUseCase: UpdateFoodUseCase,
        validator: FoodValidator = FoodValidator()
    ) {
        self.createFoodUseCase = createFoodUseCase
        self.updateFoodUseCase = updateFoodUseCase
        self.validator = validator
        self.isEditingExistingFood = isEditingExistingFood
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
            let savedFood = if isEditingExistingFood {
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
