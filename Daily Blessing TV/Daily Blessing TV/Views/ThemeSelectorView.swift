import SwiftUI

struct ThemeSelectorView: View {
    @ObservedObject var viewModel: QuoteViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let themes = [
        ("Light", "sun.max.fill", 0),
        ("Dark", "moon.fill", 1),
        ("Colorful", "paintpalette.fill", 2)
    ]
    
    var body: some View {
        ZStack {
            themeBackground
            
            VStack(spacing: 30) {
                Text("Select Theme")
                    .font(.largeTitle)
                    .padding(.top, 50)
                
                HStack(spacing: 40) {
                    ForEach(themes, id: \.2) { theme in
                        ThemeButton(
                            title: theme.0,
                            icon: theme.1,
                            isSelected: viewModel.selectedTheme == theme.2
                        ) {
                            viewModel.selectedTheme = theme.2
                            viewModel.saveTheme()
                            dismiss()
                        }
                    }
                }
                
                Spacer()
                
                Text("Swipe down to go back")
                    .font(.caption)
                    .opacity(0.7)
                    .padding(.bottom, 50)
            }
            .foregroundColor(viewModel.selectedTheme == 1 ? .white : .black)
        }
        .ignoresSafeArea()
        .focusable()
        .onMoveCommand { direction in
            if direction == .down {
                dismiss()
            }
        }
    }
    
    @ViewBuilder
    private var themeBackground: some View {
        switch viewModel.selectedTheme {
        case 0: // Light
            Color.white.ignoresSafeArea()
        case 1: // Dark
            Color.black.ignoresSafeArea()
        case 2: // Colorful
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple, .pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        default:
            Color.blue.ignoresSafeArea()
        }
    }
}

struct ThemeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .frame(width: 100, height: 100)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                    )
                
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(), value: isSelected)
    }
}

#Preview {
    let viewModel = QuoteViewModel()
    return ThemeSelectorView(viewModel: viewModel)
}
