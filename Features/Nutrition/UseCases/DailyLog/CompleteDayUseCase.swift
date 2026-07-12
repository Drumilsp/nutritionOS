//
//  CompleteDayUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct CompleteDayUseCase {

    // MARK: - Properties

    private let dailyLogRepository: any DailyLogRepository
    private let dateProvider: any DateProvider

    // MARK: - Initialization

    init(
        dailyLogRepository: any DailyLogRepository,
        dateProvider: any DateProvider = SystemDateProvider()
    ) {
        self.dailyLogRepository = dailyLogRepository
        self.dateProvider = dateProvider
    }

    // MARK: - Public Methods

    func execute(date: Date? = nil) async throws -> DailyLog {
        try await dailyLogRepository.markDayComplete(date: date ?? dateProvider.now)
    }
}
