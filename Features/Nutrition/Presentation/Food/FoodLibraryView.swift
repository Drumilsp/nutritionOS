import SwiftUI

struct FoodLibraryView: View {
    @Bindable private var viewModel: FoodViewModel
    private let makeFoodEditorViewModel: (Food, Bool) -> FoodEditorViewModel

    @State private var query = ""
    @State private var filter: FoodLibraryFilter = .all
    @State private var sort: FoodLibrarySort = .name
    @State private var editorConfiguration: FoodEditorConfiguration?

    init(
        viewModel: FoodViewModel,
        makeFoodEditorViewModel: @escaping (Food, Bool) -> FoodEditorViewModel
    ) {
        self._viewModel = Bindable(wrappedValue: viewModel)
        self.makeFoodEditorViewModel = makeFoodEditorViewModel
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                EmptyStateView(title: "No Foods", message: "Create a food to start your library.", actionTitle: "New Food") {
                    presentNewFoodEditor()
                }
            case .error(let message):
                EmptyStateView(title: "Food Library Unavailable", message: message, systemImage: AppIcons.warning, actionTitle: "Try Again") {
                    Task { await reload() }
                }
            case .loaded(let content):
                FoodListView(content: content, viewModel: viewModel, onEdit: presentEditor)
            }
        }
        .background(AppColors.background)
        .navigationTitle("Food Library")
        .searchable(text: $query, prompt: "Search foods")
        .onChange(of: query) { _, _ in Task { await reload() } }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Button("All Foods") { select(filter: .all) }
                    Button("Favorites") { select(filter: .favorites) }
                    Button("Archived") { select(filter: .archived) }
                    Divider()
                    ForEach(FoodCategory.allCases) { category in
                        Button(category.rawValue) { select(filter: .category(category)) }
                    }
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    ForEach(FoodLibrarySort.allCases) { option in
                        Button(option.title) { select(sort: option) }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button { presentNewFoodEditor() } label: {
                    Label("New Food", systemImage: AppIcons.add)
                }
            }
        }
        .task { await reload() }
        .safeAreaInset(edge: .bottom) {
            if viewModel.canUndoArchive {
                HStack {
                    Text("Food archived")
                    Spacer()
                    Button("Undo") { Task { await viewModel.undoArchive() } }
                        .font(AppTypography.headline)
                }
                .font(AppTypography.callout)
                .padding(AppSpacing.sm)
                .foregroundStyle(AppColors.onAccent)
                .background(AppColors.accent, in: Capsule())
                .padding(AppSpacing.md)
                .accessibilityElement(children: .combine)
                .task {
                    try? await Task.sleep(for: .seconds(5))
                    viewModel.discardArchiveUndo()
                }
            }
        }
        .sheet(item: $editorConfiguration) { configuration in
            NavigationStack {
                FoodEditorView(
                    viewModel: makeFoodEditorViewModel(configuration.food, configuration.isEditing),
                    onSaved: { _ in Task { await reload() } }
                )
            }
        }
    }

    private func reload() async { await viewModel.load(query: query, filter: filter, sort: sort) }
    private func select(filter: FoodLibraryFilter) { self.filter = filter; Task { await reload() } }
    private func select(sort: FoodLibrarySort) { self.sort = sort; Task { await reload() } }
    private func presentEditor(_ food: Food) { editorConfiguration = FoodEditorConfiguration(food: food, isEditing: true) }
    private func presentNewFoodEditor() { editorConfiguration = FoodEditorConfiguration(food: Food(name: "", referenceQuantity: 100, referenceUnit: .grams, nutritionProfile: NutritionProfile()), isEditing: false) }
}

private struct FoodListView: View {
    let content: FoodLibraryContent
    let viewModel: FoodViewModel
    let onEdit: (Food) -> Void

    var body: some View {
        List {
            if content.selectedFilter != .all {
                Text(filterTitle).font(AppTypography.caption).foregroundStyle(AppColors.secondaryText)
            }
            ForEach(content.foods) { food in
                NavigationLink {
                    FoodDetailsView(food: food, viewModel: viewModel, onEdit: onEdit)
                } label: {
                    FoodRowView(food: food)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button { Task { await viewModel.toggleFavorite(id: food.id) } } label: {
                        Label(food.isFavorite ? "Unfavorite" : "Favorite", systemImage: food.isFavorite ? "star.slash" : "star")
                    }
                    .tint(AppColors.warning)
                }
                .swipeActions(edge: .trailing) {
                    if food.isArchived {
                        Button { Task { await viewModel.restore(id: food.id) } } label: { Label("Restore", systemImage: "arrow.uturn.backward") }
                        .tint(AppColors.success)
                    } else if !food.isSystemFood {
                        Button { Task { await viewModel.archive(id: food.id) } } label: { Label("Archive", systemImage: "archivebox") }
                        .tint(AppColors.secondaryText)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var filterTitle: String {
        switch content.selectedFilter {
        case .all: ""
        case .favorites: "Favorites"
        case .archived: "Archived Foods"
        case .category(let category): category.rawValue
        }
    }
}

private struct FoodEditorConfiguration: Identifiable {
    let food: Food
    let isEditing: Bool
    var id: UUID { food.id }
}

#Preview {
    NavigationStack {
        FoodLibraryView(
            viewModel: AppDependencies(persistenceConfiguration: .testing).makeFoodViewModel(),
            makeFoodEditorViewModel: { food, isEditing in
                AppDependencies(persistenceConfiguration: .testing).makeFoodEditorViewModel(food: food, isEditingExistingFood: isEditing)
            }
        )
    }
}
