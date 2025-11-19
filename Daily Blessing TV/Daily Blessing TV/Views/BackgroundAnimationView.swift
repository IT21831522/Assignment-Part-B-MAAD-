import SwiftUI

struct BackgroundAnimationView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var animateGradient = false
    
    var body: some View {
        if let gradientColors = themeManager.currentTheme.gradient {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 10.0)
                        .repeatForever(autoreverses: true)
                ) {
                    animateGradient.toggle()
                }
            }
        } else {
            // Solid color background
            themeManager.currentTheme.backgroundColor
                .edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: - Preview
struct BackgroundAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundAnimationView()
            .environmentObject(ThemeManager.shared)
    }
}
