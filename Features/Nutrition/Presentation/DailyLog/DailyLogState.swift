import Foundation

enum DailyLogState {
    case loading
    case loaded(DailyLog)
    case empty
    case error(String)
}
