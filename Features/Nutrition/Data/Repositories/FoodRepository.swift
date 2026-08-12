//
//  FoodRepository.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Provides asynchronous persistence operations for food templates.
protocol FoodRepository {
    func save(_ food: Food) async throws -> Food
    func food(id: UUID) async throws -> Food
    func allFoods() async throws -> [Food]
    func searchFoods(query: String) async throws -> [Food]
    func favoriteFoods() async throws -> [Food]
    func recentlyUsedFoods(limit: Int) async throws -> [Food]
    func foods(category: String) async throws -> [Food]
    func update(_ food: Food) async throws -> Food
    func archiveFood(id: UUID) async throws -> Food
    func restoreFood(id: UUID) async throws -> Food
    func setFavorite(id: UUID, isFavorite: Bool) async throws -> Food
    func markUsed(id: UUID, at date: Date) async throws -> Food
    func deleteFood(id: UUID) async throws
    func deleteAllFoods() async throws
}
