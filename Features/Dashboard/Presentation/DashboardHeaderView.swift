//
//  DashboardHeaderView.swift
//  Nutri
//
//  Created by Codex on 13/07/26.
//

import SwiftUI

struct DashboardHeaderView: View {

    // MARK: - Properties

    let data: DashboardData

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(data.greeting)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)
            Text(data.currentDate, format: .dateTime.weekday(.wide).month(.wide).day())
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
