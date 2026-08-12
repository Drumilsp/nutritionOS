import Foundation

struct GetUnitSettingsUseCase {
    private let getPreferences: GetAppPreferencesUseCase
    init(settingsRepository: any SettingsRepository) { getPreferences = GetAppPreferencesUseCase(settingsRepository: settingsRepository) }
    func execute() async throws -> AppPreferences { try await getPreferences.execute() }
}
