import Combine
import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published private(set) var state: HistoryState = .loading
    private let getHistoryUseCase: GetHistoryUseCase
    private let searchHistoryUseCase: SearchHistoryUseCase
    init(getHistoryUseCase: GetHistoryUseCase, searchHistoryUseCase: SearchHistoryUseCase) { self.getHistoryUseCase = getHistoryUseCase; self.searchHistoryUseCase = searchHistoryUseCase }
    func load(from startDate: Date, to endDate: Date) async {
        state = .loading
        do { let logs = try await getHistoryUseCase.execute(from: startDate, to: endDate); state = logs.isEmpty ? .empty : .loaded(logs) }
        catch { state = .error("Unable to load history.") }
    }
    func search(query: String, from startDate: Date, to endDate: Date) async {
        state = .loading
        do { let logs = try await searchHistoryUseCase.execute(query: query, from: startDate, to: endDate); state = logs.isEmpty ? .empty : .loaded(logs) }
        catch { state = .error("Unable to search history.") }
    }
}
