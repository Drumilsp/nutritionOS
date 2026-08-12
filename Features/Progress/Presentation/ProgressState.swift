import Foundation

enum ProgressScreenState {
    case loading
    case loaded(ProgressSnapshot)
    case empty
    case error(String)
}
