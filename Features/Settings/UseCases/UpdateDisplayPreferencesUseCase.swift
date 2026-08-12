import Foundation

struct UpdateDisplayPreferencesUseCase {
    private let updatePreferences: UpdateAppPreferencesUseCase
    init(settingsRepository: any SettingsRepository) { updatePreferences = UpdateAppPreferencesUseCase(settingsRepository: settingsRepository) }
    func execute(_ preferences: AppPreferences) async throws -> AppPreferences { try await updatePreferences.execute(preferences) }
}
