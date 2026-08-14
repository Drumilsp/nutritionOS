import SwiftUI

/// Paste personal library JSON here. Foods import before meals; meal items must reference a food by name.
struct LibraryJSONImportView: View {
    @ObservedObject var viewModel: SettingsViewModel

    @State private var json = ""
    @State private var resultMessage: String?
    @State private var isImporting = false

    var body: some View {
        Form {
            Section("Import JSON") {
                TextEditor(text: $json)
                    .font(.body.monospaced())
                    .frame(minHeight: 220)
                    .accessibilityLabel("Foods and meals JSON")
            }

            Section("Supported format") {
                Text("Paste an object with foods and meals arrays. Foods import first. Each meal item must name an imported or existing food, with a positive quantity and g, ml, or piece unit.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
                Text("{ \"foods\": [{ \"name\": \"Chicken Breast\", \"servingSize\": 100, \"servingUnit\": \"g\", \"calories\": 165, \"protein\": 31, \"carbohydrates\": 0, \"fat\": 3.6, \"fiber\": 0 }], \"meals\": [{ \"name\": \"High Protein Lunch\", \"items\": [{ \"foodName\": \"Chicken Breast\", \"quantity\": 200, \"unit\": \"g\" }] }] }")
                    .font(.caption.monospaced())
                    .textSelection(.enabled)
                    .foregroundStyle(AppColors.secondaryText)
            }

            if let resultMessage {
                Section {
                    Text(resultMessage)
                        .foregroundStyle(resultMessage.hasPrefix("Imported") ? AppColors.success : AppColors.destructive)
                }
            }
        }
        .navigationTitle("Import JSON")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Import") { Task { await importJSON() } }
                    .disabled(json.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isImporting)
            }
        }
    }

    private func importJSON() async {
        isImporting = true
        resultMessage = await viewModel.importLibraryJSON(json)
        isImporting = false
    }
}
