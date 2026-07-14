import Combine
import Foundation

@MainActor
final class WeightHistoryViewModel: ObservableObject {
    @Published private(set) var state: WeightHistoryState = .loading
    @Published private(set) var averageWeight: Double?
    @Published private(set) var trend: ProgressTrend?
    private let getWeightHistoryUseCase: GetWeightHistoryUseCase
    init(getWeightHistoryUseCase: GetWeightHistoryUseCase) { self.getWeightHistoryUseCase = getWeightHistoryUseCase }
    func load(from startDate: Date? = nil, to endDate: Date? = nil) async {
        state = .loading
        do { let entries = try await getWeightHistoryUseCase.execute(from: startDate, to: endDate); averageWeight = entries.isEmpty ? nil : entries.map(\.weight).reduce(0, +) / Double(entries.count); trend = ProgressAnalyticsCalculator.weightHistoryTrend(entries); state = entries.isEmpty ? .empty : .loaded(entries) }
        catch { state = .error("Unable to load weight history.") }
    }
}
