import SwiftUI

/// Defines the stable primary navigation destinations for Founder Edition.
enum AppTab: Hashable {
    case today
    case progress
    case settings

    // MARK: - Presentation

    var title: String {
        switch self {
        case .today: "Today"
        case .progress: "Progress"
        case .settings: "Settings"
        }
    }

    var icon: String {
        switch self {
        case .today: AppIcons.today
        case .progress: AppIcons.progress
        case .settings: AppIcons.settings
        }
    }

    var placeholderMessage: String {
        switch self {
        case .today: "Your daily nutrition summary will appear here."
        case .progress: "Your nutrition and weight trends will appear here."
        case .settings: "Your preferences and goals will appear here."
        }
    }
}
