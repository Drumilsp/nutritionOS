import Foundation

struct GetGoalProgressUseCase {
    private let dailyLogRepository: any DailyLogRepository
    private let settingsRepository: any SettingsRepository
    private let dateProvider: any DateProvider

    init(dailyLogRepository: any DailyLogRepository, settingsRepository: any SettingsRepository, dateProvider: any DateProvider = SystemDateProvider()) {
        self.dailyLogRepository = dailyLogRepository
        self.settingsRepository = settingsRepository
        self.dateProvider = dateProvider
    }

    func execute() async throws -> [GoalProgress] {
        let today = dateProvider.now
        guard try await dailyLogRepository.exists(date: today) else { return [] }
        let log = try await dailyLogRepository.log(date: today)
        let settings = try await settingsRepository.goalSettings()
        let totals = DailyLogCalculations.totals(for: log)
        let values: [(ProgressMetric, Double, Double)] = [
            (.calories, totals.calories, log.calorieGoalSnapshot),
            (.protein, totals.protein, settings.dailyProteinGoal),
            (.carbohydrates, totals.carbohydrates, settings.dailyCarbohydrateGoal),
            (.fat, totals.fat, settings.dailyFatGoal)
        ]
        return values.filter { $0.2 > 0 }.map { GoalProgress(metric: $0.0, currentValue: $0.1, goal: $0.2) }
    }
}
