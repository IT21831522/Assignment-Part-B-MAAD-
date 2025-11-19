import SwiftUI

@main
struct Daily_Blessing_TVApp: App {
    @StateObject private var viewModel = QuoteViewModel()
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                QuoteView(viewModel: viewModel)
                    .navigationBarHidden(true)
            }
            .environmentObject(viewModel)
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.currentTheme.id == 1 ? .dark : .light)
        }
    }
}
