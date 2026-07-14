import Foundation

enum LoggedEntryState {
    case viewing(TimelineEntry)
    case editing(TimelineEntry)
    case deleted
    case error(String)
}
