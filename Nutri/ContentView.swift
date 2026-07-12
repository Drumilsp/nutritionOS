//
//  ContentView.swift
//  Nutri
//
//  Created by Drumil Patil on 10/07/26.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    private let dependencies: AppDependencies

    // MARK: - Initialization

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Body

    var body: some View {
        DashboardView(
            viewModel: dependencies.makeDashboardViewModel()
        )
    }
}

#Preview {
    ContentView(dependencies: AppDependencies(persistenceConfiguration: .testing))
}
