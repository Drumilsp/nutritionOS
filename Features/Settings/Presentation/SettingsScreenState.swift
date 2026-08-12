import Foundation

enum SettingsScreenState {
    case loading
    case loaded(SettingsSummary)
    case error(String)
}
