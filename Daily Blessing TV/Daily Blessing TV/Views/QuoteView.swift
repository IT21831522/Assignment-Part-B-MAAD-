import SwiftUI

struct QuoteView: View {
    @ObservedObject var viewModel: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isFavorite = false
    @State private var showFavorites = false
    @State private var showThemes = false
    
    var body: some View {
        ZStack {
            // Background
            if let currentQuote = viewModel.currentQuote {
                themeBackground
                    .overlay(
                        // Quote Card
                        Button(action: {
                            // Handle select button press
                            viewModel.toggleFavorite(quote: currentQuote)
                            isFavorite.toggle()
                        }) {
                            VStack(spacing: 30) {
                                Spacer()
                                
                                // Quote Text
                                Text("\"\(currentQuote.text)\"")
                                    .font(.system(size: 48, weight: .light, design: .serif))
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .transition(.opacity)
                                
                                // Author
                                Text("- \(currentQuote.author)")
                                    .font(.system(size: 32, weight: .medium, design: .serif))
                                    .opacity(0.8)
                                    .transition(.opacity)
                                
                                // Category
                                Text(currentQuote.category.uppercased())
                                    .font(.caption)
                                    .padding(8)
                                    .background(Capsule().fill(Color.white.opacity(0.2)))
                                    .padding(.top, 10)
                                
                                Spacer()
                                
                                // Controls Info
                                VStack(spacing: 15) {
                                    HStack(spacing: 30) {
                                        ControlInfo(icon: "arrow.left", label: "Previous")
                                        ControlInfo(icon: "heart.fill", 
                                                    label: viewModel.isFavorite(currentQuote) ? "Remove Fav" : "Add Fav")
                                        ControlInfo(icon: "arrow.right", label: "Next")
                                    }
                                    
                                    Text(viewModel.isAutoScrolling ? "Auto-scroll: ON" : "Auto-scroll: OFF")
                                        .font(.caption)
                                        .opacity(0.7)
                                }
                                .padding(.bottom, 50)
                            }
                            .padding(40)
                            .foregroundColor(themeManager.currentTheme.textColor)
                        }
                            .buttonStyle(CardButtonStyle())
                    )
                    .focusable()
                    .onMoveCommand { direction in
                        switch direction {
                        case .left:
                            viewModel.previousQuote()
                        case .right:
                            viewModel.nextQuote()
                        case .up:
                            showThemes = true
                        case .down:
                            showFavorites = true
                        default:
                            break
                        }
                    }
                    .onPlayPauseCommand {
                        viewModel.toggleAutoScroll()
                    }
                    .fullScreenCover(isPresented: $showFavorites) {
                        FavoritesView(viewModel: viewModel)
                    }
                    .fullScreenCover(isPresented: $showThemes) {
                        ThemeSelectorView(viewModel: viewModel)
                    }
            } else {
                ProgressView("Loading quotes...")
            }
        }
        .onAppear {
            isFavorite = viewModel.isFavorite(viewModel.currentQuote ?? Quote.example)
        }
        .onChange(of: viewModel.currentQuote) { _ in
            if let quote = viewModel.currentQuote {
                isFavorite = viewModel.isFavorite(quote)
            }
        }
    }
    
    @ViewBuilder
    private var themeBackground: some View {
        ZStack {
            // Use the new BackgroundAnimationView that reads from themeManager
            BackgroundAnimationView()
                .edgesIgnoringSafeArea(.all)
            
            // Add an overlay based on the theme
            if themeManager.currentTheme.id == 0 {
                // Light theme overlay
                Color.white.opacity(0.7).edgesIgnoringSafeArea(.all)
            } else if themeManager.currentTheme.id == 1 {
                // Dark theme overlay
                Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            } else {
                // Colorful theme overlay (semi-transparent dark)
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    struct ControlInfo: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let icon: String
        let label: String
        
        var body: some View {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(themeManager.currentTheme.textColor)
        }
        
        #Preview {
            let viewModel = QuoteViewModel()
            return QuoteView(viewModel: viewModel)
                .environmentObject(ThemeManager.shared)
        }
    }}
