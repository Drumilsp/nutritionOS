//
//  MealListState.swift
//  Nutri
//

import Foundation

enum MealLibraryScreenState {
    case loading
    case loaded(MealLibraryContent)
    case empty
    case error(String)
}

struct MealLibraryContent {
    let meals: [Meal]
    let selectedFilter: MealLibraryFilter
    let selectedSort: MealLibrarySort
}

enum MealLibraryFilter: Equatable {
    case all
    case favorites
    case archived
}

enum MealLibrarySort: String, CaseIterable, Identifiable {
    case name
    case recentlyUsed
    case recentlyUpdated
    case createdDate

    var id: Self { self }

    var title: String {
        switch self {
        case .name: "Name"
        case .recentlyUsed: "Recently Used"
        case .recentlyUpdated: "Recently Updated"
        case .createdDate: "Created Date"
        }
    }
}
