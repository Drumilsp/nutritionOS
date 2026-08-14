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
    @State private var quantityValidationMessage: String?
    @State private var waterValidationMessage: String?
    @FocusState private var isQuantityFocused: Bool
    @FocusState private var isWaterAmountFocused: Bool

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
            .sheet(item: $selectedFood) { food in foodQuantitySheet(food) }
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

    private func foodQuantitySheet(_ food: Food) -> some View {
        VStack(spacing: AppSpacing.lg) {
            Text(food.name).font(AppTypography.title)
            Text("\(quantity) \(food.referenceUnit.name)")
                .font(AppTypography.headline)
                .monospacedDigit()
                .foregroundStyle(AppColors.secondaryText)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                ForEach(quickQuantities(for: food), id: \.self) { amount in
                    Button(quantityLabel(amount, unit: food.referenceUnit)) {
                        quantity = amount.formatted()
                        isQuantityFocused = false
                    }
                    .buttonStyle(.bordered)
                }
                Button("Custom") { isQuantityFocused = true }
                    .buttonStyle(.bordered)
            }
            NutritionTextField("Custom quantity", text: $quantity, prompt: "Amount", keyboardType: .decimalPad)
                .focused($isQuantityFocused)
                .onChange(of: quantity) { _, _ in quantityValidationMessage = nil }
            if let quantityValidationMessage {
                Text(quantityValidationMessage).foregroundStyle(AppColors.destructive)
            }
            PrimaryButton("Log") { Task { await save(food: food) } }
        }
        .padding(AppSpacing.lg)
        .presentationDetents([.medium])
    }

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
        guard let loggedQuantity = Double(quantity), loggedQuantity.isFinite, loggedQuantity > 0 else {
            quantityValidationMessage = "Enter a valid quantity greater than zero."
            return
        }
        await logFoodViewModel.save(foodID: food.id, quantity: loggedQuantity)
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
            Text("\(waterAmount) ml")
                .font(AppTypography.headline)
                .monospacedDigit()
                .foregroundStyle(AppColors.secondaryText)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                ForEach([100.0, 250.0, 500.0, 1_000.0], id: \.self) { amount in
                    Button(waterAmountLabel(amount)) {
                        waterAmount = amount.formatted()
                        isWaterAmountFocused = false
                    }
                    .buttonStyle(.bordered)
                }
                Button("Custom") { isWaterAmountFocused = true }
                    .buttonStyle(.bordered)
            }
            NutritionTextField("Amount", text: $waterAmount, prompt: "mL", keyboardType: .decimalPad)
                .focused($isWaterAmountFocused)
                .onChange(of: waterAmount) { _, _ in waterValidationMessage = nil }
            if let waterValidationMessage {
                Text(waterValidationMessage).foregroundStyle(AppColors.destructive)
            }
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
        guard let amount = Double(waterAmount), amount.isFinite, amount > 0 else {
            waterValidationMessage = "Enter a valid water amount greater than zero."
            return
        }
        await logWaterViewModel.save(amount: amount)
        if case .saved = logWaterViewModel.state { completeLog(message: "Water logged") }
    }

    private func quickQuantities(for food: Food) -> [Double] {
        if food.referenceUnit == .grams {
            return [50, 100, 200, 400]
        }

        return (1...4).map { food.referenceQuantity * Double($0) }
    }

    private func quantityLabel(_ amount: Double, unit: ServingUnit) -> String {
        "\(amount.formatted()) \(unit.name)"
    }

    private func waterAmountLabel(_ amount: Double) -> String {
        amount == 1_000 ? "1 L" : "\(amount.formatted()) ml"
    }
}
