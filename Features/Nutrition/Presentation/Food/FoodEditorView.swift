import SwiftUI

struct FoodEditorView: View {

    // MARK: - Properties

    let viewModel: FoodEditorViewModel
    let onSaved: (Food) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var category: String
    @State private var servingQuantity: String
    @State private var servingUnit: ServingUnit
    @State private var calories: String
    @State private var protein: String
    @State private var carbohydrates: String
    @State private var fat: String
    @State private var fibre: String
    @State private var notes: String
    @State private var inputValidationMessage: String?

    // MARK: - Initialization

    init(viewModel: FoodEditorViewModel, onSaved: @escaping (Food) -> Void) {
        self.viewModel = viewModel
        self.onSaved = onSaved

        let food = viewModel.editingFood
        _name = State(initialValue: food.name)
        _category = State(initialValue: food.category ?? "")
        _servingQuantity = State(initialValue: food.referenceQuantity.formatted())
        _servingUnit = State(initialValue: food.referenceUnit)
        _calories = State(initialValue: Self.value(for: .calories, in: food).formatted())
        _protein = State(initialValue: Self.value(for: .protein, in: food).formatted())
        _carbohydrates = State(initialValue: Self.value(for: .carbohydrates, in: food).formatted())
        _fat = State(initialValue: Self.value(for: .fat, in: food).formatted())
        _fibre = State(initialValue: Self.value(for: .fibre, in: food).formatted())
        _notes = State(initialValue: food.notes ?? "")
    }

    // MARK: - Body

    var body: some View {
        Form {
            Section("Food") {
                TextField("Name", text: $name)
                Picker("Category", selection: $category) {
                    Text("Uncategorized").tag("")
                    ForEach(FoodCategory.allCases) { category in
                        Text(category.rawValue).tag(category.rawValue)
                    }
                }
            }

            Section("Serving") {
                TextField("Quantity", text: $servingQuantity)
                    .keyboardType(.decimalPad)
                    .onChange(of: servingQuantity) { _, value in
                        servingQuantity = sanitizedNumericInput(value)
                        inputValidationMessage = nil
                    }
                Picker("Unit", selection: $servingUnit) {
                    Text("g").tag(ServingUnit.grams)
                    Text("ml").tag(ServingUnit.millilitres)
                    Text("piece").tag(ServingUnit.piece)
                }
            }

            Section("Nutrition per serving") {
                nutritionField("Calories", value: $calories, unit: "kcal")
                nutritionField("Protein", value: $protein, unit: "g")
                nutritionField("Carbohydrates", value: $carbohydrates, unit: "g")
                nutritionField("Fat", value: $fat, unit: "g")
                nutritionField("Fiber", value: $fibre, unit: "g")
            }

            Section("Notes") {
                TextField("Optional notes", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }

            if case .validationError(let errors) = viewModel.state {
                Section {
                    Text(errors.map(\.localizedDescription).joined(separator: "\n"))
                        .foregroundStyle(AppColors.destructive)
                }
            } else if case .error(let message) = viewModel.state {
                Section {
                    Text(message).foregroundStyle(AppColors.destructive)
                }
            } else if let inputValidationMessage {
                Section {
                    Text(inputValidationMessage).foregroundStyle(AppColors.destructive)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { Task { await save() } }
                    .disabled(isSaving)
            }
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: - Private Methods

    private func nutritionField(
        _ title: String,
        value: Binding<String>,
        unit: String
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField("0", text: value)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .onChange(of: value.wrappedValue) { _, newValue in
                    value.wrappedValue = sanitizedNumericInput(newValue)
                    inputValidationMessage = nil
                }
                .accessibilityLabel(title)
            Text(unit).foregroundStyle(AppColors.secondaryText)
        }
    }

    private func save() async {
        guard hasValidNumericInput else {
            inputValidationMessage = "Enter valid numeric values for serving quantity and nutrition."
            return
        }
        await viewModel.save(foodFromInput)
        if case .saved(let food) = viewModel.state {
            onSaved(food)
            dismiss()
        }
    }

    private var foodFromInput: Food {
        let existingFood = viewModel.editingFood
        return Food(
            id: existingFood.id,
            name: name,
            category: category.isEmpty ? nil : category,
            referenceQuantity: Double(servingQuantity) ?? 0,
            referenceUnit: servingUnit,
            nutritionProfile: NutritionProfile(nutrientValues: [
                nutrientValue(.calories, value: calories, unit: .kilocalories),
                nutrientValue(.protein, value: protein, unit: .grams),
                nutrientValue(.carbohydrates, value: carbohydrates, unit: .grams),
                nutrientValue(.fat, value: fat, unit: .grams),
                nutrientValue(.fibre, value: fibre, unit: .grams)
            ]),
            notes: notes,
            isSystemFood: existingFood.isSystemFood,
            isFavorite: existingFood.isFavorite,
            isArchived: existingFood.isArchived,
            lastUsedAt: existingFood.lastUsedAt,
            createdAt: existingFood.createdAt,
            updatedAt: existingFood.updatedAt
        )
    }

    private var title: String { viewModel.isEditingExistingFood ? "Edit Food" : "New Food" }
    private var isSaving: Bool { if case .saving = viewModel.state { true } else { false } }

    private var hasValidNumericInput: Bool {
        [servingQuantity, calories, protein, carbohydrates, fat, fibre].allSatisfy { value in
            guard let number = Double(value) else { return false }
            return number.isFinite && number >= 0
        }
    }

    private func sanitizedNumericInput(_ input: String) -> String {
        var result = ""
        var includesDecimalSeparator = false

        for character in input {
            if character.isNumber {
                result.append(character)
            } else if character == ".", !includesDecimalSeparator {
                result.append(character)
                includesDecimalSeparator = true
            }
        }

        return result
    }

    private func nutrientValue(
        _ nutrientType: NutrientType,
        value: String,
        unit: NutritionUnit
    ) -> NutrientValue {
        NutrientValue(nutrientType: nutrientType, value: Double(value) ?? 0, unit: unit)
    }

    private static func value(for nutrientType: NutrientType, in food: Food) -> Double {
        food.nutritionProfile.value(for: nutrientType)
    }
}

#Preview {
    NavigationStack {
        FoodEditorView(
            viewModel: AppDependencies(persistenceConfiguration: .testing).makeFoodEditorViewModel(
                food: Food(name: "", referenceQuantity: 100, referenceUnit: .grams, nutritionProfile: NutritionProfile()),
                isEditingExistingFood: false
            ),
            onSaved: { _ in }
        )
    }
}
