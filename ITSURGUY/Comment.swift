import Foundation

struct Comment: Codable, Equatable {
    let id: String
    let postId: String
    let anonymousHandle: String
    let content: String
    var upvotes: Int
    var downvotes: Int
    let timeAgo: String
    var hasUserVoted: Bool
    let timestamp: Date
    let isReported: Bool
    let parentCommentId: String?
    
    init(
        id: String,
        postId: String,
        anonymousHandle: String,
        content: String,
        upvotes: Int,
        downvotes: Int,
        timeAgo: String,
        hasUserVoted: Bool,
        timestamp: Date, // ✅ Include this
        isReported: Bool = false,
        parentCommentId: String? = nil
    ) {
        self.id = id
        self.postId = postId
        self.anonymousHandle = anonymousHandle
        self.content = content
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.timeAgo = timeAgo
        self.hasUserVoted = hasUserVoted
        self.timestamp = timestamp // ✅ Must assign this
        self.isReported = isReported
        self.parentCommentId = parentCommentId
    }
}
