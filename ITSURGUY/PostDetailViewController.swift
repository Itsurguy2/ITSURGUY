//
//  PostDetailViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/6/25.
//


import UIKit

class PostDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryBadge: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var triggerWarningView: UIView!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var upvoteCountLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var downvoteCountLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postCommentButton: UIButton!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentsTableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var post: Post!
    var comments: [Comment] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔴 PostDetailViewController viewDidLoad - YOU ARE ON POST DETAIL SCREEN")
        if let currentPost = post {
                print("🟢 Post is set: \(currentPost.content)")
            } else {
                print("🔴 ERROR: Post is nil! Cannot display post details or add comments.")
            }
        setupUI()
        setupTableView()
        setupCommentTextView()
        configureWithPost()
        loadComments()
    }
    
    
    
    // MARK: - Setup Methods
    
    private func postComment() {
        guard let currentPost = post else {
            print("Error: post is nil, cannot post comment")
            let alert = UIAlertController(title: "Error", message: "Unable to post comment. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        guard commentTextView.textColor != UIColor.placeholderText,
              !commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let commentText = commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newComment = Comment(
            id: UUID().uuidString,
            postId: currentPost.id,
            anonymousHandle: "Anonymous Guy #\(Int.random(in: 100...999))",
            content: commentText,
            upvotes: 0,
            downvotes: 0,
            timeAgo: "now",
            hasUserVoted: false,
            timestamp: Date()
        )

        comments.insert(newComment, at: 0)
        commentsTableView.reloadData()
        updateTableViewHeight()
        
        commentTextView.text = "Share your thoughts anonymously..."
        commentTextView.textColor = UIColor.placeholderText
        postCommentButton.isEnabled = false
        commentTextView.resignFirstResponder()
        
        let alert = UIAlertController(
            title: "Comment Posted",
            message: "Your anonymous comment has been added.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        title = "Post Details"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(moreOptionsButtonTapped)
        )
        
        postContainerView.backgroundColor = UIColor.secondarySystemGroupedBackground
        postContainerView.layer.cornerRadius = 12
        
        avatarView.layer.cornerRadius = 20
        avatarLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        avatarLabel.textAlignment = .center
        avatarLabel.textColor = .white
        
        categoryBadge.layer.cornerRadius = 8
        categoryBadge.layer.masksToBounds = true
        categoryBadge.textAlignment = .center
        categoryBadge.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        categoryBadge.textColor = .white
        
        triggerWarningView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        triggerWarningView.layer.cornerRadius = 6
        triggerWarningView.isHidden = true
        
        setupActionButtons()
        
        postCommentButton.backgroundColor = UIColor.systemBlue
        postCommentButton.setTitleColor(.white, for: .normal)
        postCommentButton.layer.cornerRadius = 8
        postCommentButton.isEnabled = false
    }
    
    private func setupActionButtons() {
        upvoteButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        downvoteButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        reportButton.setImage(UIImage(systemName: "flag"), for: .normal)
        
        [upvoteButton, downvoteButton, shareButton, reportButton].forEach { button in
            button?.tintColor = UIColor.systemGray
            button?.backgroundColor = UIColor.tertiarySystemGroupedBackground
            button?.layer.cornerRadius = 6
        }
    }
    
    private func setupTableView() {
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")
        commentsTableView.separatorStyle = .none
        commentsTableView.backgroundColor = UIColor.clear
        commentsTableView.isScrollEnabled = false
    }
    
    private func setupCommentTextView() {
        commentTextView.delegate = self
        commentTextView.layer.cornerRadius = 8
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        commentTextView.font = UIFont.systemFont(ofSize: 14)
        commentTextView.text = "Share your thoughts anonymously..."
        commentTextView.textColor = UIColor.placeholderText
    }
    
    private func configureWithPost() {
        guard let post = post else { return }
        
        let initials = generateAvatarInitials(from: post.anonymousHandle)
        avatarLabel.text = initials
        avatarView.backgroundColor = generateAvatarColor(from: post.anonymousHandle)
        
        handleLabel.text = post.anonymousHandle
        timeLabel.text = "\(post.category.emoji) \(post.category.rawValue) • \(post.timeAgo)"
        postContentLabel.text = post.content
        
        categoryBadge.text = post.category.emoji
        categoryBadge.backgroundColor = UIColor(hexString: post.category.color)
        
        triggerWarningView.isHidden = !post.hasTriggerWarning
        
        upvoteCountLabel.text = "\(post.upvotes)"
        downvoteCountLabel.text = "\(post.downvotes)"
        
        updateVoteButtonStates()
    }
    
    private func updateVoteButtonStates() {
        guard let post = post else { return }
        
        if post.hasUserVoted {
            upvoteButton.tintColor = UIColor.systemBlue
            upvoteButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            upvoteCountLabel.textColor = UIColor.systemBlue
        } else {
            upvoteButton.tintColor = UIColor.systemGray
            upvoteButton.backgroundColor = UIColor.tertiarySystemGroupedBackground
            upvoteCountLabel.textColor = UIColor.secondaryLabel
        }
    }
    
    private func loadComments() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.comments = self.generateSampleComments()
            self.commentsTableView.reloadData()
            self.updateTableViewHeight()
        }
    }
    
    private func generateSampleComments() -> [Comment] {
        // Use a safe postId - either from the post or a default value
        let postId = post?.id ?? "default_post_id"
        
        return [
            Comment(
                id: "c1",
                postId: postId,
                anonymousHandle: "Anonymous Guy #2",
                content: "Bro, imposter syndrome is so real. I felt the same way when I got promoted. Just remember they promoted YOU for a reason. Trust the process and don't be afraid to ask questions.",
                upvotes: 12,
                downvotes: 0,
                timeAgo: "1h ago",
                hasUserVoted: false, timestamp: Date()
            ),
            Comment(
                id: "c2",
                postId: postId,
                anonymousHandle: "Anonymous Guy #5",
                content: "Been there man. What helped me was documenting everything I learned and keeping a 'wins' journal. You got this! 💪",
                upvotes: 8,
                downvotes: 0,
                timeAgo: "45m ago",
                hasUserVoted: true, timestamp: Date()
            ),
            Comment(
                id: "c3",
                postId: postId,
                anonymousHandle: "Anonymous Guy #7",
                content: "Honestly, everyone feels like they don't know what they're doing sometimes. The fact that you care about doing well shows you're the right person for the job.",
                upvotes: 15,
                downvotes: 1,
                timeAgo: "30m ago",
                hasUserVoted: false, timestamp: Date()
            )
        ]
    }
    
    private func updateTableViewHeight() {
        commentsTableView.layoutIfNeeded()
        let maxHeight: CGFloat = 400  // Set a maximum height
        let contentHeight = commentsTableView.contentSize.height
        commentsTableViewHeightConstraint.constant = min(contentHeight, maxHeight)
        view.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    @IBAction func upvoteButtonTapped(_ sender: UIButton) {
        handleVote(voteType: .upvote)
    }
    
    @IBAction func downvoteButtonTapped(_ sender: UIButton) {
        handleVote(voteType: .downvote)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        sharePost()
    }
    
    @IBAction func reportButtonTapped(_ sender: UIButton) {
        reportPost()
    }
    
    @IBAction func postCommentButtonTapped(_ sender: UIButton) {
        print("🔴 PostDetailViewController postCommentButtonTapped - THIS IS THE COMMENT BUTTON")
            postComment()
        postComment()
    }
    
    @objc private func moreOptionsButtonTapped() {
        showMoreOptions()
    }
    
    
    
    // MARK: - Helper Methods
    private func handleVote(voteType: VoteType) {
        
        guard var currentPost = post else {
            print("Warning: Cannot vote - post is nil")
            return
        }
        
        switch voteType {
        case .upvote:
            if currentPost.hasUserVoted {
                currentPost.upvotes -= 1
                currentPost.hasUserVoted = false
            } else {
                currentPost.upvotes += 1
                currentPost.hasUserVoted = true
            }
        case .downvote:
            if currentPost.hasUserVoted {
                currentPost.downvotes -= 1
                currentPost.hasUserVoted = false
            } else {
                currentPost.downvotes += 1
                currentPost.hasUserVoted = true
            }
        }
        
        // Update the post property with the modified version
        self.post = currentPost
        
        // Update UI
        upvoteCountLabel.text = "\(currentPost.upvotes)"
        downvoteCountLabel.text = "\(currentPost.downvotes)"
        updateVoteButtonStates()
    }
    
    private func sharePost() {
        guard let post = post else { return }
        
        let shareText = "Check out this discussion on ItsUrGuy: \"\(post.content.prefix(100))...\""
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityVC, animated: true)
    }
    
    private func reportPost() {
        let alert = UIAlertController(
            title: "Report Post",
            message: "Why are you reporting this content?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Harassment or Bullying", style: .default) { _ in
            self.submitReport(reason: "harassment")
        })
        
        alert.addAction(UIAlertAction(title: "Harmful or Dangerous Content", style: .default) { _ in
            self.submitReport(reason: "harmful")
        })
        
        alert.addAction(UIAlertAction(title: "Spam or Irrelevant", style: .default) { _ in
            self.submitReport(reason: "spam")
        })
        
        alert.addAction(UIAlertAction(title: "False Information", style: .default) { _ in
            self.submitReport(reason: "misinformation")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = reportButton
            popover.sourceRect = reportButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func submitReport(reason: String) {
        print("Reporting post  \(post?.id ?? "unknown") for reason: \(reason)")
        
        let alert = UIAlertController(
            title: "Report Submitted",
            message: "Thank you for helping keep our community safe. Our moderation team will review this content.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showMoreOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Block Anonymous User", style: .default) { _ in
            self.blockUser()
        })
        
        alert.addAction(UIAlertAction(title: "Save Post", style: .default) { _ in
            self.savePost()
        })
        
        alert.addAction(UIAlertAction(title: "Copy Text", style: .default) { _ in
            self.copyPostText()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    private func blockUser() {
        let alert = UIAlertController(
            title: "Block User",
            message: "You won't see posts from \(post?.anonymousHandle ?? ("unkonown")) anymore. This action can be undone in settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Block", style: .destructive) { _ in
            print("Blocked user: \(self.post?.anonymousHandle ?? ("unkonown"))")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func savePost() {
        print("Saved post: \(post?.id ?? ("unkonown"))")
        
        let alert = UIAlertController(
            title: "Post Saved",
            message: "This post has been saved to your collection.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func copyPostText() {
        UIPasteboard.general.string = post?.content
        
        let alert = UIAlertController(
            title: "Copied",
            message: "Post text copied to clipboard.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    

    private func generateAvatarInitials(from handle: String) -> String {
        let components = handle.components(separatedBy: "#")
        if components.count > 1, let number = components.last {
            return "A\(number)"
        }
        return "AG"
    }
    
    private func generateAvatarColor(from handle: String) -> UIColor {
        let hash = handle.hashValue
        let colors: [UIColor] = [
            .systemBlue, .systemGreen, .systemIndigo,
            .systemOrange, .systemPurple, .systemRed,
            .systemTeal, .systemYellow
        ]
        let index = abs(hash) % colors.count
        return colors[index]
    }
}

// MARK: - UITextViewDelegate
extension PostDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = ""
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share your thoughts anonymously..."
            textView.textColor = UIColor.placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let hasText = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && textView.textColor != UIColor.placeholderText
        postCommentButton.isEnabled = hasText
    }
}

// MARK: - UITableViewDataSource
extension PostDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        cell.configure(with: comment)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - CommentTableViewCellDelegate
extension PostDetailViewController: CommentTableViewCellDelegate {
    func didTapUpvoteComment(for commentId: String) {
        if let index = comments.firstIndex(where: { $0.id == commentId }) {
            var comment = comments[index]
            if comment.hasUserVoted {
                comment.upvotes -= 1
                comment.hasUserVoted = false
            } else {
                comment.upvotes += 1
                comment.hasUserVoted = true
            }
            comments[index] = comment
            commentsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func didTapDownvoteComment(for commentId: String) {
        if let index = comments.firstIndex(where: { $0.id == commentId }) {
            var comment = comments[index]
            if comment.hasUserVoted {
                comment.downvotes -= 1
                comment.hasUserVoted = false
            } else {
                comment.downvotes += 1
                comment.hasUserVoted = true
            }
            comments[index] = comment
            commentsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func didTapReportComment(for commentId: String) {
        let alert = UIAlertController(
            title: "Report Comment",
            message: "Why are you reporting this comment?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Harassment or Bullying", style: .default) { _ in
            self.submitCommentReport(commentId: commentId, reason: "harassment")
        })
        
        alert.addAction(UIAlertAction(title: "Harmful Content", style: .default) { _ in
            self.submitCommentReport(commentId: commentId, reason: "harmful")
        })
        
        alert.addAction(UIAlertAction(title: "Spam", style: .default) { _ in
            self.submitCommentReport(commentId: commentId, reason: "spam")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func submitCommentReport(commentId: String, reason: String) {
        print("Reporting comment \(commentId) for reason: \(reason)")
        
        let alert = UIAlertController(
            title: "Report Submitted",
            message: "Thank you for reporting. We'll review this comment.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "ShowPostDetail",
              let destination = segue.destination as? PostDetailViewController,
              let post = sender as? Post {
               destination.post = post
           }
       }

}
