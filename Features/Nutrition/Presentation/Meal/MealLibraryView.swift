import SwiftUI

struct MealLibraryView: View {
    @Bindable private var viewModel: MealListViewModel
    private let makeMealEditorViewModel: (Meal, Bool) -> MealEditorViewModel
    private let logMeal: (Meal) -> Void

    @State private var query = ""
    @State private var filter: MealLibraryFilter = .all
    @State private var sort: MealLibrarySort = .name
    @State private var editorConfiguration: MealEditorConfiguration?

    init(
        viewModel: MealListViewModel,
        makeMealEditorViewModel: @escaping (Meal, Bool) -> MealEditorViewModel,
        logMeal: @escaping (Meal) -> Void
    ) {
        self._viewModel = Bindable(wrappedValue: viewModel)
        self.makeMealEditorViewModel = makeMealEditorViewModel
        self.logMeal = logMeal
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                EmptyStateView(title: "No Meals", message: "Create a meal to start your library.", actionTitle: "New Meal") {
                    presentNewMealEditor()
                }
            case .error(let message):
                EmptyStateView(title: "Meal Library Unavailable", message: message, systemImage: AppIcons.warning, actionTitle: "Try Again") {
                    Task { await reload() }
                }
            case .loaded(let content):
                List {
                    if content.selectedFilter != .all {
                        Text(filterTitle).font(AppTypography.caption).foregroundStyle(AppColors.secondaryText)
                    }
                    ForEach(content.meals) { meal in
                        NavigationLink {
                            MealDetailsView(meal: meal, viewModel: viewModel, onEdit: presentEditor, onLog: logMeal)
                        } label: {
                            MealRowView(meal: meal)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button { Task { await viewModel.toggleFavorite(id: meal.id) } } label: {
                                Label(meal.isFavorite ? "Unfavorite" : "Favorite", systemImage: meal.isFavorite ? "star.slash" : "star")
                            }
                            .tint(AppColors.warning)
                        }
                        .swipeActions(edge: .trailing) {
                            if meal.isArchived {
                                Button { Task { await viewModel.restore(id: meal.id) } } label: {
                                    Label("Restore", systemImage: "arrow.uturn.backward")
                                }
                                .tint(AppColors.success)
                            } else {
                                Button { Task { await viewModel.archive(id: meal.id) } } label: {
                                    Label("Archive", systemImage: "archivebox")
                                }
                                .tint(AppColors.secondaryText)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .background(AppColors.background)
        .navigationTitle("Meal Library")
        .searchable(text: $query, prompt: "Search meals")
        .onChange(of: query) { _, _ in Task { await reload() } }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Button("All Meals") { select(filter: .all) }
                    Button("Favorites") { select(filter: .favorites) }
                    Button("Archived") { select(filter: .archived) }
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    ForEach(MealLibrarySort.allCases) { option in
                        Button(option.title) { select(sort: option) }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button { presentNewMealEditor() } label: {
                    Label("New Meal", systemImage: AppIcons.add)
                }
            }
        }
        .task { await reload() }
        .sheet(item: $editorConfiguration) { configuration in
            NavigationStack {
                MealEditorView(
                    viewModel: makeMealEditorViewModel(configuration.meal, configuration.isEditing),
                    onSaved: { _ in Task { await reload() }
                    }
                )
            }
        }
    }

    private var filterTitle: String {
        switch filter {
        case .all: ""
        case .favorites: "Favorites"
        case .archived: "Archived Meals"
        }
    }

    private func reload() async { await viewModel.load(query: query, filter: filter, sort: sort) }
    private func select(filter: MealLibraryFilter) { self.filter = filter; Task { await reload() } }
    private func select(sort: MealLibrarySort) { self.sort = sort; Task { await reload() } }
    private func presentEditor(_ meal: Meal) { editorConfiguration = MealEditorConfiguration(meal: meal, isEditing: true) }
    private func presentNewMealEditor() { editorConfiguration = MealEditorConfiguration(meal: Meal(name: "", mealItems: []), isEditing: false) }
}

private struct MealRowView: View {
    let meal: Meal

    var body: some View {
        MetricRow(
            title: meal.name,
            value: NutritionFormatter.energy(meal.nutritionProfile().value(for: .calories)),
            systemImage: AppIcons.createMeal
        )
        .accessibilityLabel("\(meal.name), \(meal.mealItems.count) foods, \(NutritionFormatter.energy(meal.nutritionProfile().value(for: .calories)))")
    }
}

private struct MealEditorConfiguration: Identifiable {
    let meal: Meal
    let isEditing: Bool
    var id: UUID { meal.id }
}
