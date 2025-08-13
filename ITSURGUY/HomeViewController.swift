//
//  HomeViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/6/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var feedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Properties
    var posts: [Post] = []
    var currentFeedType: FeedType = .trending
    
    enum FeedType: Int {
        case trending = 0
        case recent = 1
        case following = 2
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadPosts()
        
        // ADD ONLY THIS LINE:
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePostCreated(_:)),
            name: NSNotification.Name("PostCreated"),
            object: nil
        )
    }
       
       
       @objc private func handlePostCreated(_ notification: Notification) {
           
           loadPosts()
           
           
           if let newPost = notification.object as? Post {
               
               if currentFeedType == .recent {
                   posts.insert(newPost, at: 0)
                   postsTableView.reloadData()
               }
           }
       }
       
    
       
       deinit {
           NotificationCenter.default.removeObserver(self)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh posts when returning to this view
        loadPosts()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "ItsUrGuy"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup segmented control
        feedSegmentedControl.selectedSegmentIndex = 0
        feedSegmentedControl.addTarget(self, action: #selector(feedTypeChanged(_:)), for: .valueChanged)
        
        // Setup refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        postsTableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        postsTableView.separatorStyle = .none
        postsTableView.backgroundColor = UIColor.systemGroupedBackground
    }
    
    // MARK: - Data Loading
    private func loadPosts() {
        // Show loading indicator
        showLoadingIndicator()
        
        // Simulate API call - replace with actual networking
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.posts = self.generateSamplePostsForFeedType(self.currentFeedType)
            self.postsTableView.reloadData()
            self.showEmptyStateIfNeeded()
            self.hideLoadingIndicator()
            self.postsTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func generateSamplePostsForFeedType(_ feedType: FeedType) -> [Post] {
        switch feedType {
        case .trending:
            return generateTrendingPosts()
        case .recent:
            return generateRecentPosts()
        case .following:
            return generateFollowingPosts()
        }
    }
    
    private func generateTrendingPosts() -> [Post] {
        return [
            Post(
                id: "1",
                anonymousHandle: "Anonymous Guy #1",
                content: "Just got promoted to senior developer but honestly feeling major imposter syndrome. Anyone else dealt with this? How do you handle the pressure when everyone expects you to have all the answers?",
                category: .workLife,
                upvotes: 47,
                downvotes: 2,
                commentCount: 23,
                timeAgo: "2h ago",
                hasUserVoted: false
            ),
            Post(
                id: "3",
                anonymousHandle: "Anonymous Guy #3",
                content: "Mental health check - how's everyone doing today? Been having a rough week with anxiety and just wanted to see how the community is holding up. We got this 💪",
                category: .mentalHealth,
                upvotes: 89,
                downvotes: 1,
                commentCount: 45,
                timeAgo: "6h ago",
                hasUserVoted: true
            ),
            Post(
                id: "4",
                anonymousHandle: "Anonymous Guy #4",
                content: "Finally started going to therapy and it's been a game changer. For any guys on the fence about it - it's not weak to get help. Best decision I've made for myself.",
                category: .mentalHealth,
                upvotes: 156,
                downvotes: 3,
                commentCount: 67,
                timeAgo: "8h ago",
                hasUserVoted: false
            ),
            Post(
                id: "2",
                anonymousHandle: "Anonymous Guy #2",
                content: "Anyone else struggling with dating apps? Feel like I'm just not getting any matches despite putting effort into my profile. Starting to mess with my confidence tbh",
                category: .relationships,
                upvotes: 31,
                downvotes: 5,
                commentCount: 18,
                timeAgo: "4h ago",
                hasUserVoted: false
            )
        ]
    }
    
    private func generateRecentPosts() -> [Post] {
        return [
            Post(
                id: "r1",
                anonymousHandle: "Anonymous Guy #12",
                content: "Just had the worst job interview ever. Completely blanked on basic questions I know by heart. Why does anxiety have to kick in at the worst times?",
                category: .workLife,
                upvotes: 5,
                downvotes: 0,
                commentCount: 2,
                timeAgo: "3m ago",
                hasUserVoted: false
            ),
            Post(
                id: "r2",
                anonymousHandle: "Anonymous Guy #8",
                content: "Grocery shopping alone hits different when you're 30+ and single. Anyone else feel like everyone's staring at your sad bachelor cart?",
                category: .realTalk,
                upvotes: 12,
                downvotes: 1,
                commentCount: 7,
                timeAgo: "15m ago",
                hasUserVoted: false
            ),
            Post(
                id: "r3",
                anonymousHandle: "Anonymous Guy #15",
                content: "My dad just told me he's proud of me for the first time in years. I'm 28 and it still means everything. Don't underestimate the power of those words, guys.",
                category: .relationships,
                upvotes: 34,
                downvotes: 0,
                commentCount: 11,
                timeAgo: "45m ago",
                hasUserVoted: true
            ),
            Post(
                id: "r4",
                anonymousHandle: "Anonymous Guy #22",
                content: "Started going to the gym 3 months ago. Finally seeing some progress and feeling more confident. The mental benefits are honestly better than the physical ones.",
                category: .healthFitness,
                upvotes: 18,
                downvotes: 0,
                commentCount: 6,
                timeAgo: "1h ago",
                hasUserVoted: false
            ),
            Post(
                id: "r5",
                anonymousHandle: "Anonymous Guy #9",
                content: "Moved to a new city 6 months ago and still haven't made any real friends. How do you even meet people as an adult? Work colleagues don't count.",
                category: .realTalk,
                upvotes: 23,
                downvotes: 2,
                commentCount: 15,
                timeAgo: "1h ago",
                hasUserVoted: false
            )
        ]
    }
    
    private func generateFollowingPosts() -> [Post] {
        // For demo purposes, show some posts. In a real app, this would be empty if user follows no one
        // Set this based on actual user following status or demo mode
        let hasFollowing = UserDefaults.standard.bool(forKey: "userHasFollowing")
        
        // For demo, default to true if not set
        if (UserDefaults.standard.object(forKey: "userHasFollowing") == nil) != nil {
            UserDefaults.standard.set(true, forKey: "userHasFollowing")
        }
        
        if !hasFollowing {
            return [] // Return empty array to show empty state
        }
        
        return [
            Post(
                id: "f1",
                anonymousHandle: "Anonymous Guy #7", // User follows this person
                content: "Update on my job search: Got 3 rejections this week but also 2 new interviews lined up. The grind continues. Thanks everyone for the support on my last post.",
                category: .workLife,
                upvotes: 15,
                downvotes: 0,
                commentCount: 8,
                timeAgo: "2h ago",
                hasUserVoted: true
            ),
            Post(
                id: "f2",
                anonymousHandle: "Anonymous Guy #14", // User follows this person
                content: "6 months sober today. Some days are still hard but this community keeps me going. To anyone struggling - you're not alone and it does get better.",
                category: .mentalHealth,
                upvotes: 67,
                downvotes: 0,
                commentCount: 24,
                timeAgo: "5h ago",
                hasUserVoted: true
            ),
            Post(
                id: "f3",
                anonymousHandle: "Anonymous Guy #3", // User follows this person
                content: "Follow-up to my anxiety post: Started meditation like you guys suggested. Only 5 minutes a day but it's actually helping. Small steps count.",
                category: .mentalHealth,
                upvotes: 28,
                downvotes: 0,
                commentCount: 12,
                timeAgo: "1d ago",
                hasUserVoted: false
            ),
            Post(
                id: "f4",
                anonymousHandle: "Anonymous Guy #19", // User follows this person
                content: "The girl I've been talking to for 3 months just said she wants to be 'just friends.' Back to square one. At least I tried, right? 😅",
                category: .relationships,
                upvotes: 41,
                downvotes: 2,
                commentCount: 19,
                timeAgo: "1d ago",
                hasUserVoted: false
            )
        ]
    }
    
    // MARK: - Empty State Handling
    private func showEmptyStateIfNeeded() {
        if posts.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    private func showEmptyState() {
        let emptyLabel = UILabel()
        emptyLabel.text = getEmptyStateMessage()
        emptyLabel.textColor = UIColor.secondaryLabel
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.tag = 999 // Tag to find and remove later
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func hideEmptyState() {
        if let emptyLabel = view.viewWithTag(999) {
            emptyLabel.removeFromSuperview()
        }
    }
    
    private func getEmptyStateMessage() -> String {
        switch currentFeedType {
        case .trending:
            return "No trending posts right now.\nCheck back later!"
        case .recent:
            return "No recent posts found.\nBe the first to post!"
        case .following:
            return "You're not following anyone yet.\n\nDiscover users by engaging with posts and tapping their profile to follow them!"
        }
    }
    
    // MARK: - IBActions
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refreshPosts()
    }
    
    @objc private func feedTypeChanged(_ sender: UISegmentedControl) {
        currentFeedType = FeedType(rawValue: sender.selectedSegmentIndex) ?? .trending
        
        // Show loading state immediately for better UX
        showLoadingIndicator()
        
        // Add slight delay to show loading state, then load new content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.loadPosts()
        }
        
        // Update title based on selected feed
        updateNavigationTitle()
    }
    
    private func updateNavigationTitle() {
        switch currentFeedType {
        case .trending:
            title = "ItsUrGuy"
        case .recent:
            title = "Recent Posts"
        case .following:
            title = "Following"
        }
    }
    
    @objc private func refreshPosts() {
        loadPosts()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostDetail",
           let destinationVC = segue.destination as? PostDetailViewController,
           let indexPath = postsTableView.indexPathForSelectedRow {
            destinationVC.post = posts[indexPath.row]
        }
    }
    
    // MARK: - Helper Methods
    private func showLoadingIndicator() {
        // Implement loading indicator
        DispatchQueue.main.async {
            // Add activity indicator to navigation bar or show loading overlay
        }
    }
    
    private func hideLoadingIndicator() {
        // Hide loading indicator
        DispatchQueue.main.async {
            // Remove activity indicator
        }
    }
    
    private func handlePostVote(postId: String, voteType: VoteType) {
        // Find the post and update vote count
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            var post = posts[index]
            
            switch voteType {
            case .upvote:
                if post.hasUserVoted {
                    post.upvotes -= 1
                    post.hasUserVoted = false
                } else {
                    post.upvotes += 1
                    post.hasUserVoted = true
                }
            case .downvote:
                if post.hasUserVoted {
                    post.downvotes -= 1
                    post.hasUserVoted = false
                } else {
                    post.downvotes += 1
                    post.hasUserVoted = true
                }
            }
            
            posts[index] = post
            postsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    private func reportPost(postId: String) {
        let alert = UIAlertController(
            title: "Report Post",
            message: "Why are you reporting this post?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Harassment or Bullying", style: .default) { _ in
            self.submitReport(postId: postId, reason: "harassment")
        })
        
        alert.addAction(UIAlertAction(title: "Harmful Content", style: .default) { _ in
            self.submitReport(postId: postId, reason: "harmful")
        })
        
        alert.addAction(UIAlertAction(title: "Spam", style: .default) { _ in
            self.submitReport(postId: postId, reason: "spam")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func submitReport(postId: String, reason: String) {
        // Submit report to backend
        print("Reporting post \(postId) for reason: \(reason)")
        
        let alert = UIAlertController(
            title: "Report Submitted",
            message: "Thank you for helping keep our community safe. We'll review this content.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        cell.configure(with: post)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showPostDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - PostTableViewCellDelegate
extension HomeViewController: PostTableViewCellDelegate {
    func didTapUpvote(for postId: String) {
        handlePostVote(postId: postId, voteType: .upvote)
    }
    
    func didTapDownvote(for postId: String) {
        handlePostVote(postId: postId, voteType: .downvote)
    }
    
    func didTapReport(for postId: String) {
        reportPost(postId: postId)
    }
    
    func didTapComment(for postId: String) {
        // Navigate to post detail for commenting
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            let indexPath = IndexPath(row: index, section: 0)
            postsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            performSegue(withIdentifier: "showPostDetail", sender: nil)
        }
    }
}



// MARK: - Supporting Enums
enum VoteType {
    case upvote
    case downvote
}
