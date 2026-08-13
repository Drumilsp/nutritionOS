import SwiftUI

struct QuickLogSheetView: View {

    // MARK: - Properties

    @ObservedObject private var dailyLogViewModel: DailyLogViewModel
    @ObservedObject private var logFoodViewModel: LogFoodViewModel
    @ObservedObject private var logMealViewModel: LogMealViewModel
    @ObservedObject private var logWaterViewModel: LogWaterViewModel
    private let makeFoodEditorViewModel: (Food, Bool) -> FoodEditorViewModel
    private let makeMealEditorViewModel: (Meal, Bool) -> MealEditorViewModel
    private let onLogCompleted: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var selectedFood: Food?
    @State private var selectedMeal: Meal?
    @State private var quantity = "1"
    @State private var isCreatingFood = false
    @State private var isCreatingMeal = false
    @State private var isLoggingWater = false
    @State private var waterAmount = "250"

    // MARK: - Initialization

    init(
        dailyLogViewModel: DailyLogViewModel,
        logFoodViewModel: LogFoodViewModel,
        logMealViewModel: LogMealViewModel,
        logWaterViewModel: LogWaterViewModel,
        makeFoodEditorViewModel: @escaping (Food, Bool) -> FoodEditorViewModel,
        makeMealEditorViewModel: @escaping (Meal, Bool) -> MealEditorViewModel,
        onLogCompleted: @escaping (String) -> Void
    ) {
        self.dailyLogViewModel = dailyLogViewModel
        self.logFoodViewModel = logFoodViewModel
        self.logMealViewModel = logMealViewModel
        self.logWaterViewModel = logWaterViewModel
        self.makeFoodEditorViewModel = makeFoodEditorViewModel
        self.makeMealEditorViewModel = makeMealEditorViewModel
        self.onLogCompleted = onLogCompleted
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                Section("Search") {
                    NutritionTextField("Search foods and meals", text: $query, prompt: "Search")
                }

                foodSection
                mealSection

                Section {
                    PrimaryButton("New Food", systemImage: AppIcons.createFood) { isCreatingFood = true }
                    SecondaryButton("New Meal", systemImage: AppIcons.createMeal) { isCreatingMeal = true }
                    SecondaryButton("Log Water", systemImage: AppIcons.water) { isLoggingWater = true }
                }
            }
            .navigationTitle("Quick Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
            .task(id: query) {
                await logFoodViewModel.search(query: query)
                await logMealViewModel.search(query: query)
            }
            .sheet(item: $selectedFood) { food in quantitySheet(title: food.name, action: { await save(food: food) }) }
            .sheet(item: $selectedMeal) { meal in quantitySheet(title: meal.name, action: { await save(meal: meal) }) }
            .sheet(isPresented: $isCreatingFood) {
                NavigationStack {
                    FoodEditorView(
                        viewModel: makeFoodEditorViewModel(newFood, false),
                        onSaved: { food in
                            selectedFood = food
                            quantity = food.referenceQuantity.formatted()
                        }
                    )
                }
            }
            .sheet(isPresented: $isCreatingMeal) {
                NavigationStack {
                    MealEditorView(
                        viewModel: makeMealEditorViewModel(newMeal, false),
                        onSaved: { meal in
                            selectedMeal = meal
                            quantity = "1"
                        }
                    )
                }
            }
            .sheet(isPresented: $isLoggingWater) { waterSheet }
        }
    }

    // MARK: - Private Views

    @ViewBuilder
    private var foodSection: some View {
        Section("Foods") {
            let foods = query.isEmpty ? dailyLogViewModel.suggestedFoods : searchedFoods
            if foods.isEmpty { Text("No foods found.").foregroundStyle(AppColors.secondaryText) }
            ForEach(foods) { food in
                Button { selectedFood = food; quantity = food.referenceQuantity.formatted() } label: { MetricRow(title: food.name, value: NutritionFormatter.energy(food.nutritionProfile.value(for: .calories)), systemImage: AppIcons.createFood) }
                    .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var mealSection: some View {
        Section("Meals") {
            let meals = query.isEmpty ? dailyLogViewModel.suggestedMeals : searchedMeals
            if meals.isEmpty { Text("No meals found.").foregroundStyle(AppColors.secondaryText) }
            ForEach(meals) { meal in
                Button { selectedMeal = meal; quantity = "1" } label: { MetricRow(title: meal.name, value: "\(meal.mealItems.count) foods", systemImage: AppIcons.createMeal) }
                    .buttonStyle(.plain)
            }
        }
    }

    private var searchedFoods: [Food] { if case .searching(let foods) = logFoodViewModel.state { foods } else { [] } }
    private var searchedMeals: [Meal] { if case .searching(let meals) = logMealViewModel.state { meals } else { [] } }

    private func quantitySheet(title: String, action: @escaping () async -> Void) -> some View {
        VStack(spacing: AppSpacing.lg) {
            Text(title).font(AppTypography.title)
            NutritionTextField("Quantity", text: $quantity, prompt: "Amount", keyboardType: .decimalPad)
            PrimaryButton("Log") { Task { await action() } }
        }
        .padding(AppSpacing.lg)
        .presentationDetents([.medium])
    }

    // MARK: - Private Methods

    private func save(food: Food) async {
        await logFoodViewModel.save(foodID: food.id, quantity: Double(quantity) ?? food.referenceQuantity)
        if case .saved = logFoodViewModel.state { completeLog(message: "Food logged") }
    }

    private func save(meal: Meal) async {
        await logMealViewModel.save(mealID: meal.id)
        if case .saved = logMealViewModel.state { completeLog(message: "Meal logged") }
    }

    private func completeLog(message: String) {
        onLogCompleted(message)
        dismiss()
    }

    private var newFood: Food {
        Food(
            name: "",
            referenceQuantity: 100,
            referenceUnit: .grams,
            nutritionProfile: NutritionProfile()
        )
    }

    private var newMeal: Meal { Meal(name: "", mealItems: []) }

    private var waterSheet: some View {
        VStack(spacing: AppSpacing.lg) {
            Text("Log Water").font(AppTypography.title)
            NutritionTextField("Amount", text: $waterAmount, prompt: "mL", keyboardType: .decimalPad)
            if case .validationError(let message) = logWaterViewModel.state {
                Text(message).foregroundStyle(AppColors.destructive)
            } else if case .error(let message) = logWaterViewModel.state {
                Text(message).foregroundStyle(AppColors.destructive)
            }
            PrimaryButton("Log Water") { Task { await saveWater() } }
        }
        .padding(AppSpacing.lg)
        .presentationDetents([.medium])
    }

    private func saveWater() async {
        await logWaterViewModel.save(amount: Double(waterAmount) ?? 0)
        if case .saved = logWaterViewModel.state { completeLog(message: "Water logged") }
    }
}
