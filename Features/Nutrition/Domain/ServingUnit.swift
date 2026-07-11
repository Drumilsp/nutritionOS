//
//  ServingUnit.swift
//  Nutri
//
//  Created by Drumil Patil on 11/07/26.
//

import Foundation

/// Represents the measurement unit for a food's reference serving.
struct ServingUnit: Hashable {

    // MARK: - Properties

    let name: String

    // MARK: - Initialization

    init(name: String) {
        self.name = name
    }

    // MARK: - Common Units

    static let grams = ServingUnit(name: "g")
    static let millilitres = ServingUnit(name: "ml")
    static let piece = ServingUnit(name: "piece")
}
