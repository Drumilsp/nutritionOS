//
//  DashboardStatusBanner.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct DashboardStatusBanner: View {

    // MARK: - Properties

    let message: String

    // MARK: - Body

    var body: some View {
        Label(message, systemImage: "exclamationmark.circle")
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.orange)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
