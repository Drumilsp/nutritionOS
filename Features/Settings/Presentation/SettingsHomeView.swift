import SwiftUI

struct SettingsHomeView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @ObservedObject var healthViewModel: HealthSettingsViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading: ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error(let message): EmptyStateView(title: "Settings Unavailable", message: message, systemImage: AppIcons.warning, actionTitle: "Try Again") { Task { await viewModel.load() } }
            case .loaded(let summary): content(summary)
            }
        }
        .background(AppColors.background)
        .navigationTitle("Settings")
        .task { await viewModel.load() }
    }

    private func content(_ summary: SettingsSummary) -> some View {
        List {
            Section("Nutrition") {
                NavigationLink("Nutrition Goals") { GoalSettingsView(viewModel: viewModel, goals: summary.goals) }
                NavigationLink("Body Measurements") { BodyMeasurementsView(viewModel: viewModel, profile: summary.profile) }
                NavigationLink("Unit Settings") { UnitSettingsView(viewModel: viewModel, preferences: summary.preferences) }
                NavigationLink("Nutrition Display") { DisplayPreferencesView(viewModel: viewModel, preferences: summary.preferences) }
            }
            Section("Management") {
                NavigationLink(value: AppNavigationDestination.food) { Label("Manage Foods", systemImage: AppIcons.createFood) }
                NavigationLink(value: AppNavigationDestination.meal) { Label("Manage Meals", systemImage: AppIcons.createMeal) }
            }
            Section("Data") {
                NavigationLink("Data Export") { DataExportView(viewModel: viewModel) }
                NavigationLink("Reset Local Data") { ResetLocalDataView(viewModel: viewModel) }.foregroundStyle(AppColors.destructive)
            }
            Section("App") {
                NavigationLink("Apple Health") { AppleHealthSettingsView(viewModel: healthViewModel) }
                NavigationLink("About") { AppInfoView(info: viewModel.appInfo) }
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct BodyMeasurementsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    let source: UserProfile
    @Environment(\.dismiss) private var dismiss
    @State private var height: String
    @State private var currentWeight: String
    @State private var targetWeight: String
    @State private var error: String?

    init(viewModel: SettingsViewModel, profile: UserProfile) {
        self.viewModel = viewModel
        source = profile
        _height = State(initialValue: profile.height.formatted())
        _currentWeight = State(initialValue: profile.currentWeight.formatted())
        _targetWeight = State(initialValue: profile.targetWeight.formatted())
    }

    var body: some View {
        Form {
            Section("Measurements") {
                field("Height", value: $height, unit: "cm")
                field("Current Weight", value: $currentWeight, unit: "kg")
                field("Target Weight", value: $targetWeight, unit: "kg")
            }
            if let error { Section { Text(error).foregroundStyle(AppColors.destructive) } }
        }
        .navigationTitle("Body Measurements").navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save") { Task { await save() } } } }
    }

    private func field(_ title: String, value: Binding<String>, unit: String) -> some View { HStack { TextField(title, text: value).keyboardType(.decimalPad); Text(unit).foregroundStyle(AppColors.secondaryText) } }
    private func save() async {
        let profile = UserProfile(id: source.id, name: source.name, dateOfBirth: source.dateOfBirth, biologicalSex: source.biologicalSex, height: Double(height) ?? -1, currentWeight: Double(currentWeight) ?? -1, targetWeight: Double(targetWeight) ?? -1, createdAt: source.createdAt, updatedAt: source.updatedAt)
        error = await viewModel.saveProfile(profile)
        if error == nil { dismiss() }
    }
}

private struct AppleHealthSettingsView: View {
    @ObservedObject var viewModel: HealthSettingsViewModel

    var body: some View {
        List {
            Section("Connection") {
                LabeledContent("Status", value: statusLabel)
                Text(statusDescription).font(AppTypography.caption).foregroundStyle(AppColors.secondaryText)
            }
            Section {
                switch viewModel.state {
                case .connected:
                    Button("Disconnect Apple Health", role: .destructive) { Task { await viewModel.disconnect() } }
                case .syncing:
                    ProgressView("Synchronizing Apple Health")
                case .unavailable:
                    EmptyView()
                default:
                    Button("Connect Apple Health") { Task { await viewModel.requestPermissions(for: [.weight, .activeEnergy]) } }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Apple Health")
        .task { await viewModel.load() }
    }

    private var statusLabel: String { switch viewModel.state { case .loading: "Checking"; case .connected: "Connected"; case .disconnected: "Not Connected"; case .unavailable: "Unavailable"; case .syncing: "Synchronizing"; case .permissionDenied: "Permission Denied"; case .error: "Error" } }
    private var statusDescription: String { switch viewModel.state { case .connected: "Weight and active energy access is enabled."; case .disconnected: "Connect Apple Health to share supported data."; case .unavailable: "Apple Health is not available on this device."; case .permissionDenied: "Apple Health permission was not granted."; case .error(let message): message; case .loading, .syncing: "Checking Apple Health availability." } }
}

private struct GoalSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    let source: GoalSettings
    @Environment(\.dismiss) private var dismiss
    @State private var protein: String
    @State private var carbohydrates: String
    @State private var fat: String
    @State private var water: String
    @State private var error: String?

    init(viewModel: SettingsViewModel, goals: GoalSettings) {
        self.viewModel = viewModel; source = goals
        _protein = State(initialValue: goals.dailyProteinGoal.formatted())
        _carbohydrates = State(initialValue: goals.dailyCarbohydrateGoal.formatted())
        _fat = State(initialValue: goals.dailyFatGoal.formatted())
        _water = State(initialValue: goals.dailyWaterGoal.formatted())
    }

    var body: some View {
        Form {
            Section("Daily Goals") {
                field("Protein", value: $protein, unit: "g")
                field("Carbohydrates", value: $carbohydrates, unit: "g")
                field("Fat", value: $fat, unit: "g")
                field("Water", value: $water, unit: "mL")
            }
            if let error { Section { Text(error).foregroundStyle(AppColors.destructive) } }
        }
        .navigationTitle("Nutrition Goals").navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save") { Task { await save() } } } }
    }

    private func field(_ title: String, value: Binding<String>, unit: String) -> some View { HStack { TextField(title, text: value).keyboardType(.decimalPad); Text(unit).foregroundStyle(AppColors.secondaryText) } }
    private func save() async {
        let goals = GoalSettings(id: source.id, goalType: source.goalType, energyBalanceTarget: source.energyBalanceTarget, goalCalculationMode: source.goalCalculationMode, activityLevel: source.activityLevel, dailyProteinGoal: Double(protein) ?? -1, dailyCarbohydrateGoal: Double(carbohydrates) ?? -1, dailyFatGoal: Double(fat) ?? -1, dailyWaterGoal: Double(water) ?? -1, goalCalculationVersion: source.goalCalculationVersion, createdAt: source.createdAt)
        error = await viewModel.saveGoals(goals)
        if error == nil { dismiss() }
    }
}

private struct UnitSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    let source: AppPreferences
    @Environment(\.dismiss) private var dismiss
    @State private var weight: WeightUnit
    @State private var height: HeightUnit
    @State private var volume: VolumeUnit

    init(viewModel: SettingsViewModel, preferences: AppPreferences) { self.viewModel = viewModel; source = preferences; _weight = State(initialValue: preferences.weightUnit); _height = State(initialValue: preferences.heightUnit); _volume = State(initialValue: preferences.volumeUnit) }
    var body: some View {
        Form {
            Picker("Weight", selection: $weight) { ForEach(WeightUnit.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) } }
            Picker("Height", selection: $height) { ForEach(HeightUnit.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) } }
            Picker("Volume", selection: $volume) { ForEach(VolumeUnit.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) } }
        }
        .navigationTitle("Unit Settings").navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save") { Task { if await viewModel.saveUnits(copy()) == nil { dismiss() } } } } }
    }
    private func copy() -> AppPreferences { AppPreferences(id: source.id, weightUnit: weight, heightUnit: height, volumeUnit: volume, energyUnit: source.energyUnit, theme: source.theme, mealReminderEnabled: source.mealReminderEnabled, waterReminderEnabled: source.waterReminderEnabled, dailyReminderEnabled: source.dailyReminderEnabled, startOfWeek: source.startOfWeek, preferredHomeTab: source.preferredHomeTab, lastUsedMealSlot: source.lastUsedMealSlot, hapticsEnabled: source.hapticsEnabled, hasCompletedOnboarding: source.hasCompletedOnboarding, createdAt: source.createdAt) }
}

private struct DisplayPreferencesView: View {
    @ObservedObject var viewModel: SettingsViewModel
    let source: AppPreferences
    @Environment(\.dismiss) private var dismiss
    @State private var theme: AppTheme
    @State private var startOfWeek: Weekday
    @State private var haptics: Bool
    init(viewModel: SettingsViewModel, preferences: AppPreferences) { self.viewModel = viewModel; source = preferences; _theme = State(initialValue: preferences.theme); _startOfWeek = State(initialValue: preferences.startOfWeek); _haptics = State(initialValue: preferences.hapticsEnabled) }
    var body: some View {
        Form {
            Picker("Theme", selection: $theme) { ForEach(AppTheme.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) } }
            Picker("Start of Week", selection: $startOfWeek) { ForEach(Weekday.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) } }
            Toggle("Haptics", isOn: $haptics)
        }
        .navigationTitle("Nutrition Display").navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save") { Task { if await viewModel.saveDisplayPreferences(copy()) == nil { dismiss() } } } } }
    }
    private func copy() -> AppPreferences { AppPreferences(id: source.id, weightUnit: source.weightUnit, heightUnit: source.heightUnit, volumeUnit: source.volumeUnit, energyUnit: source.energyUnit, theme: theme, mealReminderEnabled: source.mealReminderEnabled, waterReminderEnabled: source.waterReminderEnabled, dailyReminderEnabled: source.dailyReminderEnabled, startOfWeek: startOfWeek, preferredHomeTab: source.preferredHomeTab, lastUsedMealSlot: source.lastUsedMealSlot, hapticsEnabled: haptics, hasCompletedOnboarding: source.hasCompletedOnboarding, createdAt: source.createdAt) }
}

private struct DataExportView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View { List { Section { Button("Prepare Export") { Task { await viewModel.export() } } }; if let export = viewModel.exportedData { Section("Export") { Text(export).font(AppTypography.caption).textSelection(.enabled) } } }.listStyle(.insetGrouped).navigationTitle("Data Export") }
}

private struct ResetLocalDataView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var confirming = false
    var body: some View {
        List {
            Section {
                Text("This permanently removes all foods, meals, logs, weight entries, and settings from this device.")
                    .foregroundStyle(AppColors.secondaryText)
                Button("Reset Local Data", role: .destructive) { confirming = true }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Reset Local Data")
        .confirmationDialog("Reset all local data?", isPresented: $confirming, titleVisibility: .visible) {
            Button("Reset Local Data", role: .destructive) { Task { await viewModel.reset() } }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

private struct AppInfoView: View {
    let info: AppInfo
    var body: some View { List { Section { LabeledContent("App Name", value: info.name); LabeledContent("Version", value: info.version); LabeledContent("Build", value: info.build); LabeledContent("Environment", value: info.environment) } }.listStyle(.insetGrouped).navigationTitle("About") }
}
