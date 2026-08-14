import SwiftUI

struct ProgressHistoryCalendarView: View {
    let days: [ProgressHistoryDay]
    let hasTargetRange: Bool
    @ObservedObject var viewModel: HistoryViewModel

    @State private var query = ""
    @State private var selectedDate: Date?

    private let columns = Array(repeating: GridItem(.flexible(minimum: 36), spacing: AppSpacing.xs), count: 7)

    var body: some View {
        List {
            Section {
                TextField("Search foods and meals", text: $query)
                    .onChange(of: query) { _, _ in Task { await loadHistory() } }
            }

            Section("Calendar") {
                if !hasTargetRange {
                    Text("Energy-balance target range: Not configured")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.secondaryText)
                }
                weekdayHeader
                LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                    ForEach(filteredDays) { day in
                        Button { selectedDate = day.date } label: { dayCircle(day) }
                            .buttonStyle(.plain)
                            .accessibilityLabel(accessibilityLabel(for: day))
                    }
                }
            }

            if let selectedDay {
                Section(selectedDay.date.formatted(date: .complete, time: .omitted)) {
                    dayDetails(selectedDay)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("History")
        .task { await loadHistory() }
    }

    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.xs) {
            ForEach(Calendar.current.shortStandaloneWeekdaySymbols, id: \.self) { symbol in
                Text(String(symbol.prefix(1)))
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var filteredDays: [ProgressHistoryDay] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return days }
        guard case .loaded(let logs) = viewModel.state else { return [] }
        let matchingIDs = Set(logs.map(\.id))
        return days.filter { day in
            guard let log = day.log else { return false }
            return matchingIDs.contains(log.id)
        }
    }

    private var selectedDay: ProgressHistoryDay? {
        guard let selectedDate else { return nil }
        return days.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    private func dayCircle(_ day: ProgressHistoryDay) -> some View {
        Text(day.date.formatted(.dateTime.day()))
            .font(AppTypography.caption.weight(.semibold))
            .monospacedDigit()
            .foregroundStyle(foregroundColor(for: day))
            .frame(width: 32, height: 32)
            .background(circleColor(for: day), in: Circle())
            .overlay {
                if selectedDate.map({ Calendar.current.isDate($0, inSameDayAs: day.date) }) == true {
                    Circle().stroke(AppColors.primaryText, lineWidth: 2)
                }
            }
            .frame(minWidth: 44, minHeight: 44)
    }

    @ViewBuilder
    private func dayDetails(_ day: ProgressHistoryDay) -> some View {
        if let log = day.log {
            let totals = DailyLogCalculations.totals(for: log)
            MetricRow(title: "Calories", value: NutritionFormatter.energy(totals.calories), systemImage: AppIcons.energy)
            MetricRow(title: "Protein", value: NutritionFormatter.macro(totals.protein), tint: AppColors.accent)
            MetricRow(title: "Carbohydrates", value: NutritionFormatter.macro(totals.carbohydrates), tint: AppColors.warning)
            MetricRow(title: "Fat", value: NutritionFormatter.macro(totals.fat), tint: AppColors.fat)
            MetricRow(title: "Fiber", value: NutritionFormatter.macro(totals.fibre))
            MetricRow(title: "Water", value: WaterFormatter.string(totals.water), systemImage: AppIcons.water, tint: AppColors.success)

            if let balance = day.energyBalance {
                MetricRow(
                    title: balance <= 0 ? "Deficit" : "Surplus",
                    value: NutritionFormatter.energy(abs(balance)),
                    systemImage: AppIcons.balance,
                    tint: circleColor(for: day)
                )
            } else {
                Text("Energy balance unavailable — stored maintenance energy and Apple Health active calories are required.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
            }

            if !log.loggedFoods.isEmpty {
                Text("Logged Foods").font(AppTypography.headline)
                ForEach(log.loggedFoods) { food in
                    MetricRow(title: food.foodName, value: "\(food.loggedQuantity.formatted()) \(food.referenceUnit.name)", systemImage: AppIcons.createFood)
                }
            }
            if !log.loggedMeals.isEmpty {
                Text("Logged Meals").font(AppTypography.headline)
                ForEach(log.loggedMeals) { meal in
                    MetricRow(title: meal.mealName, value: "\(meal.loggedFoods.count) foods", systemImage: AppIcons.createMeal)
                }
            }
        } else {
            Text("No entries logged for this day.").foregroundStyle(AppColors.secondaryText)
        }
    }

    private func circleColor(for day: ProgressHistoryDay) -> Color {
        switch day.status {
        case .onTarget: AppColors.success
        case .offTarget: AppColors.destructive
        case .neutral: AppColors.surface
        }
    }

    private func foregroundColor(for day: ProgressHistoryDay) -> Color {
        switch day.status {
        case .neutral: AppColors.primaryText
        case .onTarget, .offTarget: AppColors.onAccent
        }
    }

    private func accessibilityLabel(for day: ProgressHistoryDay) -> String {
        let status: String
        switch day.status {
        case .onTarget: status = "within target range"
        case .offTarget: status = "outside target range"
        case .neutral: status = "energy balance unavailable or target range not configured"
        }
        return "\(day.date.formatted(date: .complete, time: .omitted)), \(status)"
    }

    private func loadHistory() async {
        guard let firstDate = days.first?.date, let lastDate = days.last?.date else { return }
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            await viewModel.load(from: firstDate, to: lastDate)
        } else {
            await viewModel.search(query: query, from: firstDate, to: lastDate)
        }
    }
}
