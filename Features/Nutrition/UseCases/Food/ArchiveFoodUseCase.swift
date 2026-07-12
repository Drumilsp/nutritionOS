//
//  ArchiveFoodUseCase.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

struct ArchiveFoodUseCase {

    // MARK: - Properties

    private let foodRepository: any FoodRepository

    // MARK: - Initialization

    init(foodRepository: any FoodRepository) {
        self.foodRepository = foodRepository
    }

    // MARK: - Public Methods

    func execute(id: UUID) async throws -> Food {
        try await foodRepository.archiveFood(id: id)
    }
}
