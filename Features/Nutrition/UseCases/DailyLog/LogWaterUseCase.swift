import Foundation

/// Adds a single water event to a daily timeline.
struct LogWaterUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator
    private let dateProvider: any DateProvider
    private let uuidProvider: any UUIDProvider
    init(dailyLogRepository: any DailyLogRepository, validator: DailyLogValidator = DailyLogValidator(), dateProvider: any DateProvider = SystemDateProvider(), uuidProvider: any UUIDProvider = SystemUUIDProvider()) { self.dailyLogRepository = dailyLogRepository; self.validator = validator; self.dateProvider = dateProvider; self.uuidProvider = uuidProvider }
    func execute(amount: Double, timestamp: Date? = nil) async throws -> DailyLog {
        try validator.validateLoggedQuantity(amount).throwIfInvalid()
        let time = timestamp ?? dateProvider.now
        try validator.validateTimestamp(time).throwIfInvalid()
        return try await dailyLogRepository.addWaterEntry(WaterEntry(id: uuidProvider.makeUUID(), amount: amount, timestamp: time), to: time)
    }
}
