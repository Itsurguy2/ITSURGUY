//
//  HomeViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/6/25.
//

import Foundation
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
            self.posts = self.generateSamplePosts()
            self.postsTableView.reloadData()
            self.hideLoadingIndicator()
            self.postsTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func generateSamplePosts() -> [Post] {
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
                id: "2",
                anonymousHandle: "Anonymous Guy #2",
                content: "Anyone else struggling with dating apps? Feel like I'm just not getting any matches despite putting effort into my profile. Starting to mess with my confidence tbh",
                category: .relationships,
                upvotes: 31,
                downvotes: 5,
                commentCount: 18,
                timeAgo: "4h ago",
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
            )
        ]
    }
    
    // MARK: - IBActions
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refreshPosts()
    }
    
    @objc private func feedTypeChanged(_ sender: UISegmentedControl) {
        currentFeedType = FeedType(rawValue: sender.selectedSegmentIndex) ?? .trending
        loadPosts()
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
