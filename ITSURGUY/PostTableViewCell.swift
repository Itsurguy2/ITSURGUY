//
//  PostTableView.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/6/25.
//

import Foundation
import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func didTapUpvote(for postId: String)
    func didTapDownvote(for postId: String)
    func didTapReport(for postId: String)
    func didTapComment(for postId: String)
}

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: PostTableViewCellDelegate?
    private var postId: String = ""
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let handleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        label.backgroundColor = UIColor.systemBlue
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let triggerWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "⚠️ Content Warning"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.systemOrange
        label.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let upvoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.tintColor = UIColor.systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let upvoteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let downvoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.tintColor = UIColor.systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downvoteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = UIColor.systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "flag"), for: .normal)
        button.tintColor = UIColor.systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        containerView.addSubview(handleLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(categoryBadge)
        containerView.addSubview(contentLabel)
        containerView.addSubview(triggerWarningLabel)
        containerView.addSubview(upvoteButton)
        containerView.addSubview(upvoteCountLabel)
        containerView.addSubview(downvoteButton)
        containerView.addSubview(downvoteCountLabel)
        containerView.addSubview(commentButton)
        containerView.addSubview(commentCountLabel)
        containerView.addSubview(reportButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Avatar
            avatarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            // Handle and time
            handleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            handleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            
            timeLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: 2),
            timeLabel.leadingAnchor.constraint(equalTo: handleLabel.leadingAnchor),
            
            // Category badge
            categoryBadge.centerYAnchor.constraint(equalTo: handleLabel.centerYAnchor),
            categoryBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            categoryBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            categoryBadge.heightAnchor.constraint(equalToConstant: 20),
            
            // Content
            contentLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Trigger warning
            triggerWarningLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            triggerWarningLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            triggerWarningLabel.heightAnchor.constraint(equalToConstant: 24),
            triggerWarningLabel.widthAnchor.constraint(equalToConstant: 120),
            
            // Action buttons
            upvoteButton.topAnchor.constraint(equalTo: triggerWarningLabel.bottomAnchor, constant: 12),
            upvoteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            upvoteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            upvoteButton.widthAnchor.constraint(equalToConstant: 30),
            upvoteButton.heightAnchor.constraint(equalToConstant: 30),
            
            upvoteCountLabel.centerYAnchor.constraint(equalTo: upvoteButton.centerYAnchor),
            upvoteCountLabel.leadingAnchor.constraint(equalTo: upvoteButton.trailingAnchor, constant: 4),
            
            downvoteButton.centerYAnchor.constraint(equalTo: upvoteButton.centerYAnchor),
            downvoteButton.leadingAnchor.constraint(equalTo: upvoteCountLabel.trailingAnchor, constant: 16),
            downvoteButton.widthAnchor.constraint(equalToConstant: 30),
            downvoteButton.heightAnchor.constraint(equalToConstant: 30),
            
            downvoteCountLabel.centerYAnchor.constraint(equalTo: downvoteButton.centerYAnchor),
            downvoteCountLabel.leadingAnchor.constraint(equalTo: downvoteButton.trailingAnchor, constant: 4),
            
            commentButton.centerYAnchor.constraint(equalTo: upvoteButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: downvoteCountLabel.trailingAnchor, constant: 16),
            commentButton.widthAnchor.constraint(equalToConstant: 30),
            commentButton.heightAnchor.constraint(equalToConstant: 30),
            
            commentCountLabel.centerYAnchor.constraint(equalTo: commentButton.centerYAnchor),
            commentCountLabel.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 4),
            
            reportButton.centerYAnchor.constraint(equalTo: upvoteButton.centerYAnchor),
            reportButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            reportButton.widthAnchor.constraint(equalToConstant: 30),
            reportButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupActions() {
        upvoteButton.addTarget(self, action: #selector(upvoteButtonTapped), for: .touchUpInside)
        downvoteButton.addTarget(self, action: #selector(downvoteButtonTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    func configure(with post: Post) {
        postId = post.id
        
        // Generate avatar initials and color
        let initials = generateAvatarInitials(from: post.anonymousHandle)
        avatarLabel.text = initials
        avatarView.backgroundColor = generateAvatarColor(from: post.anonymousHandle)
        
        handleLabel.text = post.anonymousHandle
        timeLabel.text = "\(post.category.emoji) \(post.category.rawValue) • \(post.timeAgo)"
        contentLabel.text = post.content
        
        // Category badge
        categoryBadge.text = post.category.emoji
        categoryBadge.backgroundColor = UIColor(hexString: post.category.color)
        
        // Trigger warning
        triggerWarningLabel.isHidden = !post.hasTriggerWarning
        
        // Vote counts
        upvoteCountLabel.text = "\(post.upvotes)"
        downvoteCountLabel.text = "\(post.downvotes)"
        commentCountLabel.text = "\(post.commentCount)"
        
        // Update vote button states
        if post.hasUserVoted {
            upvoteButton.tintColor = UIColor.systemBlue
            upvoteCountLabel.textColor = UIColor.systemBlue
        } else {
            upvoteButton.tintColor = UIColor.systemGray
            upvoteCountLabel.textColor = UIColor.secondaryLabel
        }
    }
    
    // MARK: - Actions
    @objc private func upvoteButtonTapped() {
        delegate?.didTapUpvote(for: postId)
    }
    
    @objc private func downvoteButtonTapped() {
        delegate?.didTapDownvote(for: postId)
    }
    
    @objc private func commentButtonTapped() {
        delegate?.didTapComment(for: postId)
    }
    
    @objc private func reportButtonTapped() {
        delegate?.didTapReport(for: postId)
    }
    
    // MARK: - Helper Methods
    private func generateAvatarInitials(from handle: String) -> String {
        // Extract number from "Anonymous Guy #1" format
        let components = handle.components(separatedBy: "#")
        if components.count > 1, let number = components.last {
            return "A\(number)"
        }
        return "AG"
    }
    
    private func generateAvatarColor(from handle: String) -> UIColor {
        // Generate consistent color based on handle
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

// MARK: - UIColor Extension
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
