import Foundation
import Combine

@MainActor
final class DailyLogViewModel: ObservableObject {
    @Published private(set) var state: DailyLogState = .loading
    @Published private(set) var timeline: [TimelineEntry] = []
    @Published private(set) var totals: DailyTotals?
    @Published private(set) var suggestedFoods: [Food] = []
    @Published private(set) var suggestedMeals: [Meal] = []
    private let createDailyLogIfNeededUseCase: CreateDailyLogIfNeededUseCase
    private let suggestionsUseCase: GetSuggestionsUseCase
    init(createDailyLogIfNeededUseCase: CreateDailyLogIfNeededUseCase, suggestionsUseCase: GetSuggestionsUseCase) { self.createDailyLogIfNeededUseCase = createDailyLogIfNeededUseCase; self.suggestionsUseCase = suggestionsUseCase }
    func refresh() async {
        state = .loading
        do { let log = try await createDailyLogIfNeededUseCase.execute(); timeline = DailyLogCalculations.timeline(for: log); totals = DailyLogCalculations.totals(for: log); let suggestions = try await suggestionsUseCase.execute(for: log); suggestedFoods = suggestions.foods; suggestedMeals = suggestions.meals; state = .loaded(log) } catch { state = .error(error.localizedDescription) }
    }
}
