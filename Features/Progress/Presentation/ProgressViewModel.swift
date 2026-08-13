import Combine
import Foundation

@MainActor
final class ProgressViewModel: ObservableObject {
    @Published private(set) var state: ProgressScreenState = .loading
    @Published private(set) var selectedRange: ProgressTimeRange = .sevenDays
    private let getProgressSummaryUseCase: GetProgressSummaryUseCase
    private let getNutritionTrendsUseCase: GetNutritionTrendsUseCase
    private let getConsistencyScoreUseCase: GetConsistencyScoreUseCase
    private let getTodayImpactUseCase: GetTodayImpactUseCase
    private let getProgressChartDataUseCase: GetProgressChartDataUseCase
    private let getGoalProgressUseCase: GetGoalProgressUseCase
    private let getConsistencyMetricsUseCase: GetConsistencyMetricsUseCase
    private let getDashboardSummaryUseCase: GetDashboardSummaryUseCase

    init(getProgressSummaryUseCase: GetProgressSummaryUseCase, getNutritionTrendsUseCase: GetNutritionTrendsUseCase, getConsistencyScoreUseCase: GetConsistencyScoreUseCase, getTodayImpactUseCase: GetTodayImpactUseCase, getProgressChartDataUseCase: GetProgressChartDataUseCase, getGoalProgressUseCase: GetGoalProgressUseCase, getConsistencyMetricsUseCase: GetConsistencyMetricsUseCase, getDashboardSummaryUseCase: GetDashboardSummaryUseCase) {
        self.getProgressSummaryUseCase = getProgressSummaryUseCase; self.getNutritionTrendsUseCase = getNutritionTrendsUseCase; self.getConsistencyScoreUseCase = getConsistencyScoreUseCase; self.getTodayImpactUseCase = getTodayImpactUseCase; self.getProgressChartDataUseCase = getProgressChartDataUseCase; self.getGoalProgressUseCase = getGoalProgressUseCase; self.getConsistencyMetricsUseCase = getConsistencyMetricsUseCase; self.getDashboardSummaryUseCase = getDashboardSummaryUseCase
    }

    func select(range: ProgressTimeRange) async { selectedRange = range; await load() }
    func load() async {
        state = .loading
        do {
            let charts = try await getProgressChartDataUseCase.execute(for: selectedRange)
            guard charts.contains(where: { !$0.points.isEmpty }) else { state = .empty; return }
            let summary = try await getProgressSummaryUseCase.execute(for: selectedRange)
            let trends = try await getNutritionTrendsUseCase.execute(for: selectedRange)
            let consistency = try await getConsistencyScoreUseCase.execute(for: selectedRange)
            let impact = try await getTodayImpactUseCase.execute()
            let goals = try await getGoalProgressUseCase.execute()
            let metrics = try await getConsistencyMetricsUseCase.execute(for: selectedRange)
            let today = try? await getDashboardSummaryUseCase.execute()
            state = .loaded(ProgressSnapshot(todaySummary: today, summary: summary, trends: trends, chartDatasets: charts, consistencyScore: consistency, todayImpact: impact, goalProgress: goals, consistencyMetrics: metrics))
        } catch { state = .error("Unable to load Progress.") }
    }
}
