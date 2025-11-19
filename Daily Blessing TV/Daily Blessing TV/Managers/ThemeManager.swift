import SwiftUI
import Combine

@MainActor
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: Theme {
        didSet {
            saveTheme()
        }
    }
    
    private let themeKey = "selectedTheme"
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Load saved theme or default to light
        if let data = UserDefaults.standard.data(forKey: themeKey),
           let savedTheme = try? JSONDecoder().decode(Theme.self, from: data) {
            self.currentTheme = savedTheme
        } else {
            self.currentTheme = .light
        }
    }
    
    private func saveTheme() {
        if let encoded = try? JSONEncoder().encode(currentTheme) {
            UserDefaults.standard.set(encoded, forKey: themeKey)
        }
    }
    
    // Available themes
    let allThemes: [Theme] = [.light, .dark, .colorful]
}
