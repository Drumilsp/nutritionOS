//
//  GetHistoryUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct GetHistoryUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let validator: DailyLogValidator

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        validator: DailyLogValidator = DailyLogValidator()
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.validator = validator
    }

    // MARK: - Public Methods

    func execute(from startDate: Date, to endDate: Date) async throws -> [DailyLog] {
        try validator.validateDateRange(from: startDate, to: endDate).throwIfInvalid()

        return try await dailyLogRepository.logs(from: startDate, to: endDate)
            .sorted { $0.date > $1.date }
    }
}
