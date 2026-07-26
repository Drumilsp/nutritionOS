import SwiftUI

struct ManageFoodsSettingsView: View {
    var body: some View {
        List {
            Section {
                NavigationLink(value: AppNavigationDestination.food) {
                    Label("Manage Foods", systemImage: AppIcons.createFood)
                }
                NavigationLink(value: AppNavigationDestination.meal) {
                    Label("Manage Meals", systemImage: AppIcons.createMeal)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack { ManageFoodsSettingsView() }
}
