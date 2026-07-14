import Foundation

/// Loads an existing log for a calendar day without creating unrelated logs.
struct GetDailyLogUseCase {
    private let dailyLogRepository: any DailyLogRepository
    init(dailyLogRepository: any DailyLogRepository) { self.dailyLogRepository = dailyLogRepository }
    func execute(date: Date) async throws -> DailyLog { try await dailyLogRepository.log(date: date) }
}
