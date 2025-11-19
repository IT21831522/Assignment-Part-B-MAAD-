import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30)
    ]
    
    var body: some View {
        ZStack {
            // Use the theme background
            themeManager.currentTheme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            // Add gradient overlay if needed
            if let gradientColors = themeManager.currentTheme.gradient {
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            }
            
            if viewModel.favorites.isEmpty {
                VStack {
                    Text("No favorites yet")
                        .font(.title)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    Text("Swipe up to go back")
                        .font(.caption)
                        .padding(.top, 10)
                        .foregroundColor(themeManager.currentTheme.textColor.opacity(0.8))
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(viewModel.quotes.filter { viewModel.favorites.contains($0.id) }) { quote in
                            QuoteCard(
                                quote: quote,
                                isFavorite: true,
                                theme: themeManager.currentTheme
                            ) {
                                viewModel.toggleFavorite(quote: quote)
                            }
                            .frame(height: 300)
                        }
                    }
                    .padding()
                }
                .padding(.top, 50)
            }
        }
        .ignoresSafeArea()
        .focusable()
        .onMoveCommand { direction in
            if direction == .down {
                dismiss()
            }
        }
    }
}

struct QuoteCard: View {
    let quote: Quote
    let isFavorite: Bool
    let theme: Theme
    let onFavoriteTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Text("\"\(quote.text)\"")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(theme.textColor)
            
            Text("- \(quote.author)")
                .font(.subheadline)
                .foregroundColor(theme.textColor.opacity(0.8))
            
            Text(quote.category.uppercased())
                .font(.caption)
                .padding(5)
                .background(
                    Capsule()
                        .fill(theme.accentColor.opacity(0.2))
                )
                .foregroundColor(theme.textColor)
            
            Button(action: onFavoriteTapped) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : theme.textColor.opacity(0.7))
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.backgroundColor.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(theme.accentColor.opacity(0.5), lineWidth: 1)
                )
                .shadow(radius: 10)
        )
        .padding(10)
    }
}

#Preview {
    let viewModel = QuoteViewModel()
    viewModel.favorites.insert(Quote.example.id)
    return FavoritesView(viewModel: viewModel)
        .environmentObject(ThemeManager.shared)
}
