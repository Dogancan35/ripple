import Foundation
import SwiftData

@Model
final class RippleItem {
    var id: UUID
    var content: String
    var categoryRaw: String
    var photoData: Data?
    var isReceived: Bool
    var isRead: Bool
    var timestamp: Date

    var category: RippleCategory {
        get { RippleCategory(rawValue: categoryRaw) ?? .compliment }
        set { categoryRaw = newValue.rawValue }
    }

    init(content: String, category: RippleCategory, photoData: Data? = nil, isReceived: Bool) {
        self.id = UUID()
        self.content = content
        self.categoryRaw = category.rawValue
        self.photoData = photoData
        self.isReceived = isReceived
        self.isRead = false
        self.timestamp = Date()
    }
}

enum RippleCategory: String, CaseIterable {
    case compliment = "Compliment"
    case coffee = "Coffee"
    case fare = "Fare"
    case knowledge = "Knowledge"
    case gift = "Gift"

    var icon: String {
        switch self {
        case .compliment: return "heart.fill"
        case .coffee: return "cup.and.saucer.fill"
        case .fare: return "car.fill"
        case .knowledge: return "book.fill"
        case .gift: return "gift.fill"
        }
    }

    var color: String {
        switch self {
        case .compliment: return "FF6B9D"
        case .coffee: return "C9A66B"
        case .fare: return "4ECDC4"
        case .knowledge: return "6C5CE7"
        case .gift: return "FF9F43"
        }
    }
}

// Sample ripples for demo
extension RippleItem {
    static let samples: [RippleItem] = [
        RippleItem(content: "Your smile lights up the room. Keep being you! 🌟", category: .compliment, isReceived: true),
        RippleItem(content: "Here's a virtual coffee on me. Take a break, you deserve it! ☕", category: .coffee, isReceived: true),
        RippleItem(content: "Safe travels! May the road rise to meet you. 🚗", category: .fare, isReceived: true),
        RippleItem(content: "A tip: the best time to learn something new is right now. Don't wait! 📚", category: .knowledge, isReceived: true),
        RippleItem(content: "A little surprise for you — open it with an open heart! 🎁", category: .gift, isReceived: true),
    ]
}