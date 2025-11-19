import Foundation

struct Quote: Identifiable, Codable, Equatable {
    let id = UUID()
    let text: String
    let author: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case text, author, category
    }
}

// For preview data
extension Quote {
    static let example = Quote(
        text: "Believe you can and you're halfway there.",
        author: "Theodore Roosevelt",
        category: "motivation"
    )
}
