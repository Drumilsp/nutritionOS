import Charts
import SwiftUI

struct ProgressDashboardView: View {
    @ObservedObject var viewModel: ProgressViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    @ObservedObject var weightHistoryViewModel: WeightHistoryViewModel
    @State private var customStart = Calendar.current.date(byAdding: .day, value: -29, to: .now) ?? .now
    @State private var customEnd = Date()
    @State private var historyQuery = ""

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading: ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                case .empty: EmptyStateView(title: "No Progress Yet", message: "Log nutrition or add a weight measurement to see progress.")
                case .error(let message): EmptyStateView(title: "Progress Unavailable", message: message, systemImage: AppIcons.warning, actionTitle: "Try Again") { Task { await viewModel.load() } }
                case .loaded(let snapshot): dashboard(snapshot)
                }
            }
            .navigationTitle("Progress")
            .task { await viewModel.load() }
        }
    }

    private func dashboard(_ snapshot: ProgressSnapshot) -> some View {
        List {
            Section("Time Range") {
                Picker("Time Range", selection: Binding(get: { viewModel.selectedRange }, set: { range in Task { await viewModel.select(range: range) } })) {
                    ForEach(ProgressTimeRange.allCases) { Text($0.title).tag($0) }
                    Text("Custom").tag(ProgressTimeRange.custom(customStart, customEnd))
                }.pickerStyle(.menu)
                if case .custom = viewModel.selectedRange {
                    DatePicker("Start", selection: $customStart, displayedComponents: .date)
                    DatePicker("End", selection: $customEnd, in: customStart..., displayedComponents: .date)
                    Button("Apply Range") { Task { await viewModel.select(range: .custom(customStart, customEnd)) } }
                }
            }
            Section("Today") {
                if let today = snapshot.todaySummary {
                    MetricRow(title: "Calories", value: NutritionFormatter.energy(today.caloriesConsumed), systemImage: AppIcons.energy)
                    MetricRow(title: "Protein", value: NutritionFormatter.macro(today.proteinConsumed), tint: AppColors.accent)
                    MetricRow(title: "Carbohydrates", value: NutritionFormatter.macro(today.carbohydratesConsumed))
                    MetricRow(title: "Fat", value: NutritionFormatter.macro(today.fatConsumed))
                    MetricRow(title: "Fiber", value: NutritionFormatter.macro(today.fibreConsumed))
                } else {
                    Text("No nutrition logged today.").foregroundStyle(AppColors.secondaryText)
                }
            }
            Section("Weekly Summary") {
                MetricRow(title: "Average Calories", value: NutritionFormatter.energy(snapshot.weeklySummary.averageCalories))
                MetricRow(title: "Protein", value: NutritionFormatter.macro(snapshot.weeklySummary.averageProtein), tint: AppColors.accent)
                MetricRow(title: "Carbohydrates", value: NutritionFormatter.macro(snapshot.weeklySummary.averageCarbohydrates))
                MetricRow(title: "Fat", value: NutritionFormatter.macro(snapshot.weeklySummary.averageFat))
                MetricRow(title: "Fiber", value: NutritionFormatter.macro(snapshot.weeklySummary.averageFibre))
            }
            Section("Monthly Summary") {
                MetricRow(title: "Average Calories", value: NutritionFormatter.energy(snapshot.monthlySummary.averageCalories))
                MetricRow(title: "Protein", value: NutritionFormatter.macro(snapshot.monthlySummary.averageProtein), tint: AppColors.accent)
                MetricRow(title: "Carbohydrates", value: NutritionFormatter.macro(snapshot.monthlySummary.averageCarbohydrates))
                MetricRow(title: "Fat", value: NutritionFormatter.macro(snapshot.monthlySummary.averageFat))
                MetricRow(title: "Fiber", value: NutritionFormatter.macro(snapshot.monthlySummary.averageFibre))
            }
            Section("Goal Progress") {
                if snapshot.goalProgress.isEmpty { Text("No goals are available for today.").foregroundStyle(AppColors.secondaryText) }
                ForEach(snapshot.goalProgress) { goal in
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        MetricRow(title: metricTitle(goal.metric), value: "\(formatted(goal.currentValue, metric: goal.metric)) / \(formatted(goal.goal, metric: goal.metric))")
                        ProgressView(value: goal.completionPercentage)
                        Text("\(formatted(goal.remainingValue, metric: goal.metric)) remaining · \(goal.completionPercentage.formatted(.percent.precision(.fractionLength(0))))")
                            .font(AppTypography.caption).foregroundStyle(AppColors.secondaryText).monospacedDigit()
                    }
                }
            }
            Section("Consistency") {
                MetricRow(title: "Current Streak", value: "\(snapshot.consistencyMetrics.currentStreak) days")
                MetricRow(title: "Longest Streak", value: "\(snapshot.consistencyMetrics.longestStreak) days")
                MetricRow(title: "Logged Days", value: "\(snapshot.consistencyMetrics.loggedDays)")
                MetricRow(title: "Missed Days", value: "\(snapshot.consistencyMetrics.missedDays)")
                MetricRow(title: "Weekly Consistency", value: snapshot.consistencyMetrics.weeklyConsistency.formatted(.percent.precision(.fractionLength(0))))
            }
            Section("Nutrition Trends") {
                ForEach(snapshot.chartDatasets.filter { $0.metric != .weight && $0.metric != .water }) { dataset in chart(dataset) }
            }
            Section("Body Metrics") {
                if let latest = latestWeight { MetricRow(title: "Latest Weight", value: WeightFormatter.string(latest.weight), systemImage: "scalemass") }
                if let weight = snapshot.chartDatasets.first(where: { $0.metric == .weight }) { chart(weight) }
            }
            Section("History") {
                NavigationLink("Browse History") { historyBrowser }
            }
        }
        .listStyle(.insetGrouped)
        .task { await weightHistoryViewModel.load() }
    }

    @ViewBuilder private func chart(_ dataset: ProgressChartDataset) -> some View {
        if !dataset.points.isEmpty {
            Chart(dataset.points) { point in
                LineMark(x: .value("Date", point.date), y: .value("Value", point.value))
                    .foregroundStyle(chartColor(for: dataset.metric))
                PointMark(x: .value("Date", point.date), y: .value("Value", point.value))
                    .foregroundStyle(chartColor(for: dataset.metric))
            }
            .frame(height: 150)
            .accessibilityLabel("\(metricTitle(dataset.metric)) trend chart")
        }
    }

    private var historyBrowser: some View {
        List {
            Section { TextField("Search foods and meals", text: $historyQuery).onChange(of: historyQuery) { _, _ in loadHistory() } }
            switch historyViewModel.state {
            case .loaded(let logs): ForEach(logs) { log in MetricRow(title: log.date.formatted(date: .abbreviated, time: .omitted), value: NutritionFormatter.energy(DailyLogCalculations.totals(for: log).calories)) }
            case .empty: Text("No matching history.").foregroundStyle(AppColors.secondaryText)
            case .loading: ProgressView()
            case .error(let message): Text(message).foregroundStyle(AppColors.destructive)
            }
        }
        .listStyle(.insetGrouped).navigationTitle("History")
        .task { loadHistory() }
    }

    private var latestWeight: WeightEntry? { if case .loaded(let entries) = weightHistoryViewModel.state { entries.last } else { nil } }
    private func loadHistory() {
        let dates = ProgressDateRange.dates(for: viewModel.selectedRange, now: .now, calendar: .current)
        Task { await historyViewModel.search(query: historyQuery, from: dates.start ?? .distantPast, to: dates.end) }
    }
    private func metricTitle(_ metric: ProgressMetric) -> String { switch metric { case .calories: "Calories"; case .protein: "Protein"; case .carbohydrates: "Carbohydrates"; case .fat: "Fat"; case .fibre: "Fiber"; case .water: "Water"; case .weight: "Weight" } }
    private func formatted(_ value: Double, metric: ProgressMetric) -> String { metric == .calories ? NutritionFormatter.energy(value) : NutritionFormatter.macro(value) }
    private func chartColor(for metric: ProgressMetric) -> Color { switch metric { case .protein: AppColors.accent; case .carbohydrates: AppColors.warning; case .fat: AppColors.fat; case .fibre: AppColors.success; default: AppColors.secondaryText } }
}
