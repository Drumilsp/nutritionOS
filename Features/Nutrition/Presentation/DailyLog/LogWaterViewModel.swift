import Combine
import Foundation

@MainActor
final class LogWaterViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var state: LogWaterState = .idle

    private let logWaterUseCase: LogWaterUseCase

    // MARK: - Initialization

    init(logWaterUseCase: LogWaterUseCase) {
        self.logWaterUseCase = logWaterUseCase
    }

    // MARK: - Public Methods

    func save(amount: Double, timestamp: Date? = nil) async {
        state = .saving

        do {
            _ = try await logWaterUseCase.execute(amount: amount, timestamp: timestamp)
            state = .saved
        } catch let failure as ValidationFailure {
            state = .validationError(failure.localizedDescription)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
