import Foundation
import Combine

@MainActor
final class LoggedEntryViewModel: ObservableObject {
    @Published private(set) var state: LoggedEntryState
    private let deleteLoggedEntryUseCase: DeleteLoggedEntryUseCase
    private let duplicateLoggedEntryUseCase: DuplicateLoggedEntryUseCase
    init(entry: TimelineEntry, deleteLoggedEntryUseCase: DeleteLoggedEntryUseCase, duplicateLoggedEntryUseCase: DuplicateLoggedEntryUseCase) { self.state = .viewing(entry); self.deleteLoggedEntryUseCase = deleteLoggedEntryUseCase; self.duplicateLoggedEntryUseCase = duplicateLoggedEntryUseCase }
    func edit() { if case .viewing(let entry) = state { state = .editing(entry) } }
    func duplicate(entry: TimelineEntry, date: Date) async { do { _ = try await duplicateLoggedEntryUseCase.execute(entry, date: date); state = .viewing(entry) } catch { state = .error(error.localizedDescription) } }
    func delete(entry: TimelineEntry, date: Date) async { do { _ = try await deleteLoggedEntryUseCase.execute(entry, date: date); state = .deleted } catch { state = .error(error.localizedDescription) } }
}
