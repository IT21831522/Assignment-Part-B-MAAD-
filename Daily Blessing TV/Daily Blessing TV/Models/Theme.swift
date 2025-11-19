import SwiftUI

struct Theme: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let backgroundPrimary: String
    let textPrimary: String
    let accent: String
    let gradientColors: [String]?
    
    var backgroundColor: Color {
        Color(hex: backgroundPrimary)
    }
    
    var textColor: Color {
        Color(hex: textPrimary)
    }
    
    var accentColor: Color {
        Color(hex: accent)
    }
    
    var gradient: [Color]? {
        gradientColors?.compactMap { Color(hex: $0) }
    }
    
    // Predefined themes
    static let light = Theme(
        id: 0,
        name: "Pure Serenity",
        backgroundPrimary: "#F6F7F9",
        textPrimary: "#1A1A1A",
        accent: "#3A6EA5",
        gradientColors: ["#FDFCFF", "#E6ECF5"]
    )
    
    static let dark = Theme(
        id: 1,
        name: "Midnight Calm",
        backgroundPrimary: "#0E0E0F",
        textPrimary: "#F5F5F5",
        accent: "#6A8FFF",
        gradientColors: ["#0F0F12", "#1A1D24"]
    )
    
    static let colorful = Theme(
        id: 2,
        name: "Hope & Harmony",
        backgroundPrimary: "",
        textPrimary: "#FFFFFF",
        accent: "#6A5AE0",
        gradientColors: ["#6A5AE0", "#FF6FB1", "#FFD36E"]
    )
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = (
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17,
                255
            )
        case 6: // RGB (24-bit)
            (r, g, b, a) = (
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF,
                255
            )
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF,
                int >> 24
            )
        default:
            (r, g, b, a) = (1, 1, 1, 1) // Default to white
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
