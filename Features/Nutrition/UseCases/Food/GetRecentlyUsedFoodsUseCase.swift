import Foundation

/// Retrieves recently logged active food templates for presentation.
struct GetRecentlyUsedFoodsUseCase {

    // MARK: - Properties

    private let foodRepository: any FoodRepository

    // MARK: - Initialization

    init(foodRepository: any FoodRepository) {
        self.foodRepository = foodRepository
    }

    // MARK: - Public Methods

    func execute(limit: Int) async throws -> [Food] {
        try await foodRepository.recentlyUsedFoods(limit: limit)
            .filter { !$0.isArchived }
    }
}
