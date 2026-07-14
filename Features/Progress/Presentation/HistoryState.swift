import Foundation

enum HistoryState {
    case loading
    case loaded([DailyLog])
    case empty
    case error(String)
}
