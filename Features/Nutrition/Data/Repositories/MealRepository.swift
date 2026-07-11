//
//  MealRepository.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Provides asynchronous persistence operations for meal templates.
protocol MealRepository {
    func save(_ meal: Meal) async throws -> Meal
    func meal(id: UUID) async throws -> Meal
    func allMeals() async throws -> [Meal]
    func searchMeals(query: String) async throws -> [Meal]
    func favoriteMeals() async throws -> [Meal]
    func update(_ meal: Meal) async throws -> Meal
    func archiveMeal(id: UUID) async throws -> Meal
    func restoreMeal(id: UUID) async throws -> Meal
}
