import Foundation

enum FoodLibraryScreenState {
    case loading
    case loaded(FoodLibraryContent)
    case empty
    case error(String)
}

struct FoodLibraryContent {
    let foods: [Food]
    let categories: [FoodCategory]
    let selectedFilter: FoodLibraryFilter
    let selectedSort: FoodLibrarySort
}

enum FoodLibraryFilter: Equatable {
    case all
    case favorites
    case archived
    case category(FoodCategory)
}

enum FoodLibrarySort: String, CaseIterable, Identifiable {
    case name
    case recentlyUsed

    var id: Self { self }

    var title: String {
        switch self {
        case .name: "Name"
        case .recentlyUsed: "Recently Used"
        }
    }
}
