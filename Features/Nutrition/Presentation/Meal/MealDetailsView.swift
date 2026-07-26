import SwiftUI

struct MealDetailsView: View {
    let meal: Meal
    let viewModel: MealListViewModel
    let onEdit: (Meal) -> Void
    let onLog: (Meal) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showArchiveConfirmation = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        List {
            Section("Foods") {
                ForEach(meal.mealItems) { item in
                    MetricRow(
                        title: item.foodReference.name,
                        value: "\(item.quantity.formatted()) \(item.servingUnit.name)",
                        systemImage: AppIcons.createFood
                    )
                }
            }
            Section("Nutrition totals") {
                MetricRow(title: "Calories", value: NutritionFormatter.energy(nutrition.value(for: .calories)))
                MetricRow(title: "Protein", value: NutritionFormatter.macro(nutrition.value(for: .protein)), tint: AppColors.accent)
                MetricRow(title: "Carbohydrates", value: NutritionFormatter.macro(nutrition.value(for: .carbohydrates)))
                MetricRow(title: "Fat", value: NutritionFormatter.macro(nutrition.value(for: .fat)))
                MetricRow(title: "Fibre", value: NutritionFormatter.macro(nutrition.value(for: .fibre)))
            }
            if let notes = meal.notes, !notes.isEmpty {
                Section("Notes") { Text(notes) }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(meal.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button("Log Meal", systemImage: "plus.circle") { onLog(meal) }
                    Button(meal.isFavorite ? "Remove Favorite" : "Add Favorite", systemImage: meal.isFavorite ? "star.slash" : "star") {
                        Task { await viewModel.toggleFavorite(id: meal.id) }
                    }
                    Button("Duplicate", systemImage: "plus.square.on.square") { Task { await viewModel.duplicate(id: meal.id) } }
                    Button("Edit", systemImage: "pencil") { onEdit(meal) }
                    if meal.isArchived {
                        Button("Restore", systemImage: "arrow.uturn.backward") { Task { await viewModel.restore(id: meal.id); dismiss() } }
                    } else {
                        Button("Archive", systemImage: "archivebox") { showArchiveConfirmation = true }
                    }
                    Button("Delete", systemImage: "trash", role: .destructive) { showDeleteConfirmation = true }
                } label: { Label("Actions", systemImage: "ellipsis.circle") }
            }
        }
        .confirmationDialog("Archive \(meal.name)?", isPresented: $showArchiveConfirmation, titleVisibility: .visible) {
            Button("Archive") { Task { await viewModel.archive(id: meal.id); dismiss() } }
        } message: { Text("Archived meals stay available in the Archived filter.") }
        .confirmationDialog("Delete \(meal.name)?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { Task { await viewModel.delete(id: meal.id); dismiss() } }
        } message: { Text("This permanently removes the meal template. Historical logs are not affected.") }
    }

    private var nutrition: NutritionProfile { meal.nutritionProfile() }
}
