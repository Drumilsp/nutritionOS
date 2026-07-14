import Foundation

enum ProgressState {
    case loading
    case loaded(ProgressSnapshot)
    case empty
    case error(String)
}
