import Foundation

struct GetSettingsSummaryUseCase {
    private let settingsRepository: any SettingsRepository
    init(settingsRepository: any SettingsRepository) { self.settingsRepository = settingsRepository }
    func execute() async throws -> SettingsSummary {
        let goals = try await settingsRepository.goalSettings()
        let preferences = try await settingsRepository.appPreferences()
        return SettingsSummary(goals: goals, preferences: preferences)
    }
}
