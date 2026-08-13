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
                Text(rangeDescription).font(AppTypography.caption).foregroundStyle(AppColors.secondaryText)
            }
            Section("Summary") {
                ForEach(snapshot.summary.cards.filter { [.calories, .protein, .carbohydrates, .fat, .fibre].contains($0.metric) }) { card in
                    MetricRow(title: metricTitle(card.metric), value: formatted(card.currentValue, metric: card.metric), systemImage: card.metric == .calories ? AppIcons.energy : nil, tint: card.metric == .protein ? AppColors.accent : AppColors.secondaryText)
                }
            }
            Section("Energy Balance") {
                energyBalance(snapshot.summary.energyBalance)
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
            Text(metricTitle(dataset.metric)).font(AppTypography.caption).foregroundStyle(AppColors.secondaryText)
            Chart(dataset.points) { point in
                LineMark(x: .value("Date", point.date), y: .value("Value", point.value))
                    .foregroundStyle(chartColor(for: dataset.metric))
                PointMark(x: .value("Date", point.date), y: .value("Value", point.value))
                    .foregroundStyle(chartColor(for: dataset.metric))
            }
            .chartYAxisLabel(dataset.metric == .calories ? "kcal" : "g")
            .frame(height: 170)
            .accessibilityLabel("\(metricTitle(dataset.metric)) trend chart")
        }
    }

    @ViewBuilder private func energyBalance(_ availability: EnergyBalanceAvailability) -> some View {
        switch availability {
        case .available(let consumed, let burn, let label, let amount):
            MetricRow(title: "Consumed", value: NutritionFormatter.energy(consumed), systemImage: AppIcons.energy)
            MetricRow(title: "Estimated Burn", value: NutritionFormatter.energy(burn))
            MetricRow(title: label, value: NutritionFormatter.energy(amount))
        case .tdeeNotConfigured:
            Text("Unavailable — configure a maintenance energy target to view energy balance.").foregroundStyle(AppColors.secondaryText)
        case .activeCaloriesUnavailable:
            Text("Unavailable — Apple Health active-calorie data is needed for this range.").foregroundStyle(AppColors.secondaryText)
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
    private var rangeDescription: String {
        let dates = ProgressDateRange.dates(for: viewModel.selectedRange, now: .now, calendar: .current)
        guard let start = dates.start else { return "All available history" }
        return "Showing \(start.formatted(date: .abbreviated, time: .omitted)) – \(dates.end.formatted(date: .abbreviated, time: .omitted))"
    }
    private func metricTitle(_ metric: ProgressMetric) -> String { switch metric { case .calories: "Calories"; case .protein: "Protein"; case .carbohydrates: "Carbohydrates"; case .fat: "Fat"; case .fibre: "Fiber"; case .water: "Water"; case .weight: "Weight" } }
    private func formatted(_ value: Double, metric: ProgressMetric) -> String { metric == .calories ? NutritionFormatter.energy(value) : NutritionFormatter.macro(value) }
    private func chartColor(for metric: ProgressMetric) -> Color { switch metric { case .protein: AppColors.accent; case .carbohydrates: AppColors.warning; case .fat: AppColors.fat; case .fibre: AppColors.success; default: AppColors.secondaryText } }
}
