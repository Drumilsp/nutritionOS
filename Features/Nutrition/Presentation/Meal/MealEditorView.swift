import SwiftUI

struct MealEditorView: View {
    let viewModel: MealEditorViewModel
    let onSaved: (Meal) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var notes: String
    @State private var foodQuery = ""
    @State private var isSelectingFood = false

    init(viewModel: MealEditorViewModel, onSaved: @escaping (Meal) -> Void) {
        self.viewModel = viewModel
        self.onSaved = onSaved
        let meal = viewModel.editingMeal
        _name = State(initialValue: meal.name)
        _notes = State(initialValue: meal.notes ?? "")
    }

    var body: some View {
        Form {
            Section("Meal") {
                TextField("Name", text: $name)
                    .onChange(of: name) { _, value in viewModel.updateName(value) }
            }
            Section("Foods") {
                ForEach(viewModel.editingMeal.mealItems) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.foodReference.name)
                            Text(NutritionFormatter.energy(item.foodReference.nutritionProfile.value(for: .calories)))
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.secondaryText)
                        }
                        Spacer()
                        TextField("Quantity", value: quantityBinding(for: item), format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 88)
                        Text(item.servingUnit.name).foregroundStyle(AppColors.secondaryText)
                    }
                }
                .onDelete { offsets in
                    let items = viewModel.editingMeal.mealItems
                    for index in offsets { viewModel.removeFood(itemID: items[index].id) }
                }
                .onMove(perform: viewModel.reorderFoods)
                Button("Add Food", systemImage: AppIcons.add) { isSelectingFood = true }
            }
            Section("Nutrition totals") {
                MetricRow(title: "Calories", value: NutritionFormatter.energy(nutrition.value(for: .calories)))
                MetricRow(title: "Protein", value: NutritionFormatter.macro(nutrition.value(for: .protein)), tint: AppColors.accent)
                MetricRow(title: "Carbohydrates", value: NutritionFormatter.macro(nutrition.value(for: .carbohydrates)))
                MetricRow(title: "Fat", value: NutritionFormatter.macro(nutrition.value(for: .fat)))
                MetricRow(title: "Fibre", value: NutritionFormatter.macro(nutrition.value(for: .fibre)))
            }
            Section("Notes") {
                TextField("Optional notes", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
                    .onChange(of: notes) { _, value in viewModel.editNotes(value) }
            }
            validationSection
        }
        .navigationTitle(viewModel.isEditingExistingMeal ? "Edit Meal" : "New Meal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { Task { await save() } }.disabled(isSaving)
            }
        }
        .sheet(isPresented: $isSelectingFood) {
            NavigationStack {
                List(viewModel.availableFoods) { food in
                    Button {
                        viewModel.addFood(food, quantity: food.referenceQuantity)
                        isSelectingFood = false
                    } label: {
                        MetricRow(title: food.name, value: NutritionFormatter.energy(food.nutritionProfile.value(for: .calories)), systemImage: AppIcons.createFood)
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Add Food")
                .searchable(text: $foodQuery, prompt: "Search foods")
                .task { await viewModel.searchFoods() }
                .task(id: foodQuery) { await viewModel.searchFoods(query: foodQuery) }
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { isSelectingFood = false } } }
            }
        }
    }

    @ViewBuilder
    private var validationSection: some View {
        if case .validationError(let errors) = viewModel.state {
            Section { Text(errors.map(\.localizedDescription).joined(separator: "\n")).foregroundStyle(AppColors.destructive) }
        } else if case .error(let message) = viewModel.state {
            Section { Text(message).foregroundStyle(AppColors.destructive) }
        }
    }

    private var nutrition: NutritionProfile { viewModel.editingMeal.nutritionProfile() }
    private var isSaving: Bool { if case .saving = viewModel.state { true } else { false } }

    private func quantityBinding(for item: MealItem) -> Binding<Double> {
        Binding(
            get: { item.quantity },
            set: { viewModel.changeQuantity(itemID: item.id, quantity: $0) }
        )
    }

    private func save() async {
        await viewModel.save()
        if case .saved(let meal) = viewModel.state {
            onSaved(meal)
            dismiss()
        }
    }
}
