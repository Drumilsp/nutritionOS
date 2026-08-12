import Combine
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private(set) var state: SettingsScreenState = .loading
    @Published private(set) var exportedData: String?
    @Published private(set) var appInfo: AppInfo

    private let getSettingsSummaryUseCase: GetSettingsSummaryUseCase
    private let getGoalSettingsUseCase: GetGoalSettingsUseCase
    private let updateGoalSettingsUseCase: UpdateGoalSettingsUseCase
    private let updateUnitSettingsUseCase: UpdateUnitSettingsUseCase
    private let updateDisplayPreferencesUseCase: UpdateDisplayPreferencesUseCase
    private let exportAppDataUseCase: ExportAppDataUseCase
    private let resetLocalDataUseCase: ResetLocalDataUseCase

    init(getSettingsSummaryUseCase: GetSettingsSummaryUseCase, getGoalSettingsUseCase: GetGoalSettingsUseCase, updateGoalSettingsUseCase: UpdateGoalSettingsUseCase, updateUnitSettingsUseCase: UpdateUnitSettingsUseCase, updateDisplayPreferencesUseCase: UpdateDisplayPreferencesUseCase, exportAppDataUseCase: ExportAppDataUseCase, resetLocalDataUseCase: ResetLocalDataUseCase, getAppInfoUseCase: GetAppInfoUseCase) {
        self.getSettingsSummaryUseCase = getSettingsSummaryUseCase; self.getGoalSettingsUseCase = getGoalSettingsUseCase; self.updateGoalSettingsUseCase = updateGoalSettingsUseCase; self.updateUnitSettingsUseCase = updateUnitSettingsUseCase; self.updateDisplayPreferencesUseCase = updateDisplayPreferencesUseCase; self.exportAppDataUseCase = exportAppDataUseCase; self.resetLocalDataUseCase = resetLocalDataUseCase; self.appInfo = getAppInfoUseCase.execute()
    }

    func load() async {
        state = .loading
        do { state = .loaded(try await getSettingsSummaryUseCase.execute()) }
        catch { state = .error("Unable to load settings.") }
    }

    func saveGoals(_ goals: GoalSettings) async -> String? {
        do { _ = try await updateGoalSettingsUseCase.execute(goals); await load(); return nil }
        catch let failure as ValidationFailure { return failure.localizedDescription }
        catch { return "Unable to save goals." }
    }

    func saveUnits(_ preferences: AppPreferences) async -> String? { await save(preferences, using: updateUnitSettingsUseCase) }
    func saveDisplayPreferences(_ preferences: AppPreferences) async -> String? { await save(preferences, using: updateDisplayPreferencesUseCase) }
    func export() async { do { exportedData = try await exportAppDataUseCase.execute() } catch { state = .error("Unable to export data.") } }
    func reset() async { do { try await resetLocalDataUseCase.execute(); exportedData = nil; await load() } catch { state = .error("Unable to reset local data.") } }

    private func save(_ preferences: AppPreferences, using useCase: UpdateUnitSettingsUseCase) async -> String? {
        do { _ = try await useCase.execute(preferences); await load(); return nil } catch { return "Unable to save preferences." }
    }
    private func save(_ preferences: AppPreferences, using useCase: UpdateDisplayPreferencesUseCase) async -> String? {
        do { _ = try await useCase.execute(preferences); await load(); return nil } catch { return "Unable to save preferences." }
    }
}
