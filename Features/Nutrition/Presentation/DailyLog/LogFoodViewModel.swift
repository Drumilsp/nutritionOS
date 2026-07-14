import Foundation
import Combine

@MainActor
final class LogFoodViewModel: ObservableObject {
    @Published private(set) var state: LogFoodState = .searching([])
    private let searchFoodsUseCase: SearchFoodsUseCase
    private let logFoodUseCase: LogFoodUseCase
    init(searchFoodsUseCase: SearchFoodsUseCase, logFoodUseCase: LogFoodUseCase) { self.searchFoodsUseCase = searchFoodsUseCase; self.logFoodUseCase = logFoodUseCase }
    func search(query: String) async { do { state = .searching(try await searchFoodsUseCase.execute(query: query)) } catch { state = .error(error.localizedDescription) } }
    func save(foodID: UUID, quantity: Double, mealPeriod: MealSlot? = nil, timestamp: Date? = nil) async { state = .saving; do { _ = try await logFoodUseCase.execute(foodID: foodID, quantity: quantity, mealSlot: mealPeriod ?? .other, date: timestamp); state = .saved } catch let failure as ValidationFailure { state = .validationError(failure.localizedDescription) } catch { state = .error(error.localizedDescription) } }
}
