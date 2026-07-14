import Foundation

struct UpdateDailyNotesUseCase {
    private let dailyLogRepository: any DailyLogRepository
    init(dailyLogRepository: any DailyLogRepository) { self.dailyLogRepository = dailyLogRepository }
    func execute(notes: String?, date: Date) async throws -> DailyLog { try await dailyLogRepository.updateNotes(TextNormalizer.normalizedOptionalText(notes), on: date) }
}
