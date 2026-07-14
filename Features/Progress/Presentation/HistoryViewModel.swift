import Combine
import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published private(set) var state: HistoryState = .loading
    private let getHistoryUseCase: GetHistoryUseCase
    init(getHistoryUseCase: GetHistoryUseCase) { self.getHistoryUseCase = getHistoryUseCase }
    func load(from startDate: Date, to endDate: Date) async {
        state = .loading
        do { let logs = try await getHistoryUseCase.execute(from: startDate, to: endDate); state = logs.isEmpty ? .empty : .loaded(logs) }
        catch { state = .error("Unable to load history.") }
    }
}
