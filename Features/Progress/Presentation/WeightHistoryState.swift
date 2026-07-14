import Foundation

enum WeightHistoryState {
    case loading
    case loaded([WeightEntry])
    case empty
    case error(String)
}
