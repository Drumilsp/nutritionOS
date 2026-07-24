import Foundation

/// Updates a logged water event through the daily log repository.
struct UpdateWaterEntryUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        validator: DailyLogValidator = DailyLogValidator(),
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.validator = validator
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(
        waterEntry: WaterEntry,
        amount: Double,
        timestamp: Date? = nil,
        date: Date? = nil
    ) async throws -> DailyLog {
        try validator.validateLoggedQuantity(amount).throwIfInvalid()
        let updatedTimestamp = timestamp ?? waterEntry.timestamp
        try validator.validateTimestamp(updatedTimestamp).throwIfInvalid()
        let logDate = date ?? dateProvider.now
        try validator.validateEditable(try await dailyLogRepository.log(date: logDate)).throwIfInvalid()

        return try await dailyLogRepository.updateWaterEntry(
            WaterEntry(id: waterEntry.id, amount: amount, timestamp: updatedTimestamp),
            on: logDate
        )
    }
}
