//
//  FoodCategory.swift
//  Nutri
//

import Foundation

/// Built-in categories used to organize food templates.
enum FoodCategory: String, CaseIterable, Identifiable {
    case meatAndPoultry = "Meat & Poultry"
    case seafood = "Seafood"
    case eggs = "Eggs"
    case dairy = "Dairy"
    case grainsAndCereals = "Grains & Cereals"
    case breadAndBakery = "Bread & Bakery"
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case nutsAndSeeds = "Nuts & Seeds"
    case legumes = "Legumes"
    case snacksAndSweets = "Snacks & Sweets"
    case beverages = "Beverages"
    case preparedFoods = "Prepared Foods"
    case condimentsAndSauces = "Condiments & Sauces"
    case supplements = "Supplements"
    case other = "Other"

    var id: String { rawValue }
}
