import SwiftUI

struct NutritionTextField: View {
    let title: String; let prompt: String; @Binding var text: String; let keyboardType: UIKeyboardType
    init(_ title: String, text: Binding<String>, prompt: String = "", keyboardType: UIKeyboardType = .default) { self.title = title; self._text = text; self.prompt = prompt; self.keyboardType = keyboardType }
    var body: some View { VStack(alignment: .leading, spacing: AppSpacing.xs) { Text(title).font(AppTypography.headline); TextField(prompt, text: $text).font(AppTypography.body).keyboardType(keyboardType).padding(AppSpacing.sm).frame(minHeight: 44).background(AppColors.background, in: RoundedRectangle(cornerRadius: AppRadius.small, style: .continuous)).overlay { RoundedRectangle(cornerRadius: AppRadius.small, style: .continuous).stroke(AppColors.outline, lineWidth: 1) }.accessibilityLabel(title) } }
}
#Preview { @Previewable @State var text = ""; NutritionTextField("Calories", text: $text, prompt: "e.g. 2,000", keyboardType: .numberPad).padding() }
