import SwiftUI

struct FoodDetailsView: View {
    let food: Food
    let viewModel: FoodViewModel
    let onEdit: (Food) -> Void

    @State private var showArchiveConfirmation = false
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("Nutrition per serving") {
                MetricRow(title: "Calories", value: NutritionFormatter.energy(food.nutritionProfile.value(for: .calories)))
                MetricRow(title: "Protein", value: NutritionFormatter.macro(food.nutritionProfile.value(for: .protein)), tint: AppColors.accent)
                MetricRow(title: "Carbohydrates", value: NutritionFormatter.macro(food.nutritionProfile.value(for: .carbohydrates)))
                MetricRow(title: "Fat", value: NutritionFormatter.macro(food.nutritionProfile.value(for: .fat)))
                MetricRow(title: "Fibre", value: NutritionFormatter.macro(food.nutritionProfile.value(for: .fibre)))
            }
            Section("Serving") { LabeledContent("Reference serving", value: "\(food.referenceQuantity.formatted()) \(food.referenceUnit.name)") }
            if let category = food.category { Section("Category") { Text(category) } }
            if let notes = food.notes, !notes.isEmpty { Section("Notes") { Text(notes) } }
            if food.isSystemFood { Section { Text("System foods are read-only. You can duplicate or favorite this food.").foregroundStyle(AppColors.secondaryText) } }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(food.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(food.isFavorite ? "Remove Favorite" : "Add Favorite", systemImage: food.isFavorite ? "star.slash" : "star") { Task { await viewModel.toggleFavorite(id: food.id) } }
                    Button("Duplicate", systemImage: "plus.square.on.square") { Task { await viewModel.duplicate(id: food.id) } }
                    if !food.isSystemFood {
                        Button("Edit", systemImage: "pencil") { onEdit(food) }
                        if food.isArchived {
                            Button("Restore", systemImage: "arrow.uturn.backward") { Task { await viewModel.restore(id: food.id) } }
                        } else {
                            Button("Archive", systemImage: "archivebox") { showArchiveConfirmation = true }
                        }
                        Button("Delete", systemImage: "trash", role: .destructive) { showDeleteConfirmation = true }
                    }
                } label: { Label("Actions", systemImage: "ellipsis.circle") }
            }
        }
        .confirmationDialog("Archive \(food.name)?", isPresented: $showArchiveConfirmation, titleVisibility: .visible) {
            Button("Archive") { Task { await viewModel.archive(id: food.id); dismiss() } }
        } message: { Text("Archived foods stay available in the Archived filter.") }
        .confirmationDialog("Delete \(food.name)?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { Task { await viewModel.delete(id: food.id); dismiss() } }
        } message: { Text("This permanently removes the food template. Historical logs are not affected.") }
    }
}

#Preview {
    NavigationStack {
        FoodDetailsView(food: Food(name: "Apple", referenceQuantity: 100, referenceUnit: .grams, nutritionProfile: NutritionProfile()), viewModel: AppDependencies(persistenceConfiguration: .testing).makeFoodViewModel(), onEdit: { _ in })
    }
}
