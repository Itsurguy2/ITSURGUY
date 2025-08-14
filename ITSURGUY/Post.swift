import Foundation

struct Post: Codable, Equatable {
    let id: String
    let anonymousHandle: String
    let content: String
    let category: PostCategory
    var upvotes: Int
    var downvotes: Int
    var commentCount: Int
    let timeAgo: String
    var hasUserVoted: Bool
    let imageUrl: String?
    let isReported: Bool
    let hasTriggerWarning: Bool
    
    static func == (lhs: Post, rhs: Post) -> Bool {
            return lhs.id == rhs.id
        }

    init(id: String, anonymousHandle: String, content: String, category: PostCategory, upvotes: Int, downvotes: Int, commentCount: Int, timeAgo: String, hasUserVoted: Bool, imageUrl: String? = nil, isReported: Bool = false, hasTriggerWarning: Bool = false) {
        self.id = id
        self.anonymousHandle = anonymousHandle
        self.content = content
        self.category = category
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.commentCount = commentCount
        self.timeAgo = timeAgo
        self.hasUserVoted = hasUserVoted
        self.imageUrl = imageUrl
        self.isReported = isReported
        self.hasTriggerWarning = hasTriggerWarning
    }
}


enum PostCategory: String, CaseIterable, Codable {
    case realTalk = "Real Talk"
    case workLife = "Work Life"
    case mentalHealth = "Mental Health"
    case relationships = "Relationships"
    case moneyMoves = "Money Moves"
    case sportsGaming = "Sports & Gaming"
    case healthFitness = "Health & Fitness"
    case currentEvents = "Current Events"
    
    var emoji: String {
        switch self {
        case .realTalk: return "⚡"
        case .workLife: return "💼"
        case .mentalHealth: return "🧠"
        case .relationships: return "❤️"
        case .moneyMoves: return "💰"
        case .sportsGaming: return "🎮"
        case .healthFitness: return "💪"
        case .currentEvents: return "📰"
        }
    }
    
    var color: String {
        switch self {
        case .realTalk: return "#FF6B6B"
        case .workLife: return "#4ECDC4"
        case .mentalHealth: return "#95E77E"
        case .relationships: return "#FFD93D"
        case .moneyMoves: return "#6BCB77"
        case .sportsGaming: return "#B983FF"
        case .healthFitness: return "#FF8B94"
        case .currentEvents: return "#4D96FF"
        }
    }
}
