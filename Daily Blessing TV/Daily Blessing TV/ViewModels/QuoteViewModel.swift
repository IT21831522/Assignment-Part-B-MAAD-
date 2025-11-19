import Foundation
import Combine
import SwiftUI

class QuoteViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var currentQuoteIndex = 0
    @Published var isAutoScrolling = true
    @Published var favorites: Set<UUID> = []
    @Published var selectedTheme = 0
    
    private var timer: Timer?
    private let autoScrollInterval: TimeInterval = 10.0
    
    init() {
        loadQuotes()
        loadFavorites()
        loadTheme()
        startAutoScroll()
    }
    
    // MARK: - Data Management
    
    private func loadQuotes() {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            // Fallback to example quotes if loading fails
            self.quotes = [.example]
            return
        }
        
        do {
            let decoder = JSONDecoder()
            self.quotes = try decoder.decode([Quote].self, from: data)
        } catch {
            print("Error decoding quotes: \(error)")
            self.quotes = [.example]
        }
    }
    
    // MARK: - Quote Navigation
    
    var currentQuote: Quote? {
        guard !quotes.isEmpty, currentQuoteIndex < quotes.count else { return nil }
        return quotes[currentQuoteIndex]
    }
    
    func nextQuote() {
        guard !quotes.isEmpty else { return }
        currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
    }
    
    func previousQuote() {
        guard !quotes.isEmpty else { return }
        currentQuoteIndex = (currentQuoteIndex - 1 + quotes.count) % quotes.count
    }
    
    // MARK: - Favorites
    
    func toggleFavorite(quote: Quote) {
        if favorites.contains(quote.id) {
            favorites.remove(quote.id)
        } else {
            favorites.insert(quote.id)
        }
        saveFavorites()
    }
    
    func isFavorite(_ quote: Quote) -> Bool {
        favorites.contains(quote.id)
    }
    
    private func loadFavorites() {
        if let favoritesData = UserDefaults.standard.array(forKey: "favorites") as? [String],
           !favoritesData.isEmpty {
            favorites = Set(favoritesData.compactMap { UUID(uuidString: $0) })
        }
    }
    
    private func saveFavorites() {
        let favoritesArray = Array(favorites).map { $0.uuidString }
        UserDefaults.standard.set(favoritesArray, forKey: "favorites")
    }
    
    // MARK: - Theme
    
    private func loadTheme() {
        selectedTheme = UserDefaults.standard.integer(forKey: "selectedTheme")
    }
    
    func saveTheme() {
        UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme")
    }
    
    // MARK: - Auto Scroll
    
    func toggleAutoScroll() {
        isAutoScrolling.toggle()
        isAutoScrolling ? startAutoScroll() : stopAutoScroll()
    }
    
    private func startAutoScroll() {
        stopAutoScroll()
        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { [weak self] _ in
            self?.nextQuote()
        }
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Cleanup
    
    deinit {
        stopAutoScroll()
    }
}
