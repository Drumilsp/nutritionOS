import Combine
import Foundation

enum HealthState: Equatable { case loading, connected, disconnected, unavailable, syncing, permissionDenied, error(String) }
enum SyncState: Equatable { case idle, syncing, success(Date), error(String) }

/// Manages Apple Health connection and permission state for Settings.
@MainActor
final class HealthSettingsViewModel: ObservableObject {
    @Published private(set) var state: HealthState = .loading
    private let requestPermissionsUseCase: RequestHealthPermissionsUseCase
    private let getConnectionStatusUseCase: GetHealthConnectionStatusUseCase
    private let syncHealthDataUseCase: SyncHealthDataUseCase
    private let disconnectHealthUseCase: DisconnectHealthUseCase
    init(requestPermissionsUseCase: RequestHealthPermissionsUseCase, getConnectionStatusUseCase: GetHealthConnectionStatusUseCase, syncHealthDataUseCase: SyncHealthDataUseCase, disconnectHealthUseCase: DisconnectHealthUseCase) { self.requestPermissionsUseCase = requestPermissionsUseCase; self.getConnectionStatusUseCase = getConnectionStatusUseCase; self.syncHealthDataUseCase = syncHealthDataUseCase; self.disconnectHealthUseCase = disconnectHealthUseCase }
    func load() async { state = Self.state(for: await getConnectionStatusUseCase.execute()) }
    func requestPermissions(for types: Set<HealthDataType>) async { do { try await requestPermissionsUseCase.execute(for: types); state = .connected } catch HealthRepositoryError.permissionDenied { state = .permissionDenied } catch { state = .error("Apple Health permissions could not be updated.") } }
    func sync() async { state = .syncing; do { try await syncHealthDataUseCase.execute(); state = .connected } catch { state = .error("Apple Health could not be synchronized.") } }
    func disconnect() async { do { try await disconnectHealthUseCase.execute(); state = .disconnected } catch { state = .error("Apple Health could not be disconnected.") } }

    private static func state(for status: HealthConnectionStatus) -> HealthState {
        switch status {
        case .connected: .connected
        case .disconnected: .disconnected
        case .unavailable: .unavailable
        case .syncing: .syncing
        case .permissionDenied: .permissionDenied
        case .error(let message): .error(message)
        }
    }
}

/// Manages manual synchronization progress and its most recent completion time.
@MainActor
final class HealthSyncViewModel: ObservableObject {
    @Published private(set) var state: SyncState = .idle
    private let syncHealthDataUseCase: SyncHealthDataUseCase
    init(syncHealthDataUseCase: SyncHealthDataUseCase) { self.syncHealthDataUseCase = syncHealthDataUseCase }
    func sync() async { state = .syncing; do { try await syncHealthDataUseCase.execute(); state = .success(Date()) } catch { state = .error("Apple Health could not be synchronized.") } }
}
