//
//  TextNormalizer.swift
//  Nutri
//
//  Created by Codex on 12/07/26.
//

import Foundation

/// Performs safe text normalization for user-owned labels and notes.
enum TextNormalizer {

    // MARK: - Public Methods

    static func normalizedName(_ value: String) -> String {
        normalizedSpacing(value).capitalized
    }

    static func normalizedOptionalText(_ value: String?) -> String? {
        let normalizedValue = normalizedSpacing(value ?? "")
        return normalizedValue.isEmpty ? nil : normalizedValue
    }

    static func normalizedSpacing(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(whereSeparator: { $0.isWhitespace })
            .joined(separator: " ")
    }
}
