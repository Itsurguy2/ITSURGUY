//
//  CommentTableViewCell.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/6/25.
//

import Foundation
import UIKit

protocol CommentTableViewCellDelegate: AnyObject {
    func didTapUpvoteComment(for commentId: String)
    func didTapDownvoteComment(for commentId: String)
    func didTapReportComment(for commentId: String)
}

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: CommentTableViewCellDelegate?
    private var commentId: String = ""
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tertiarySystemGroupedBackground
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let handleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
    
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reply", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.tintColor = UIColor.systemBlue
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
        containerView.addSubview(contentLabel)
        containerView.addSubview(upvoteButton)
        containerView.addSubview(upvoteCountLabel)
        containerView.addSubview(downvoteButton)
        containerView.addSubview(downvoteCountLabel)
        containerView.addSubview(reportButton)
        containerView.addSubview(replyButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Avatar
            avatarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            avatarView.widthAnchor.constraint(equalToConstant: 30),
            avatarView.heightAnchor.constraint(equalToConstant: 30),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            // Handle
            handleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            handleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            handleLabel.trailingAnchor.constraint(lessThanOrEqualTo: reportButton.leadingAnchor, constant: -8),
            
            // Content
            contentLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: handleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            // Action buttons row
            upvoteButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            upvoteButton.leadingAnchor.constraint(equalTo: handleLabel.leadingAnchor),
            upvoteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            upvoteButton.widthAnchor.constraint(equalToConstant: 25),
            upvoteButton.heightAnchor.constraint(equalToConstant: 25),
            
            upvoteCountLabel.centerYAnchor.constraint(equalTo: upvoteButton.centerYAnchor),
            upvoteCountLabel.leadingAnchor.constraint(equalTo: upvoteButton.trailingAnchor, constant: 4),
            
            downvoteButton.centerYAnchor.constraint(equalTo: upvoteButton.centerYAnchor),
            downvoteButton.leadingAnchor.constraint(equalTo: upvoteCountLabel.trailingAnchor, constant: 12),
            downvoteButton.widthAnchor.constraint(equalToConstant: 25),
            downvoteButton.heightAnchor.constraint(equalToConstant: 25),
            
            downvoteCountLabel.centerYAnchor.constraint(equalTo: downvoteButton.centerYAnchor),
            downvoteCountLabel.leadingAnchor.constraint(equalTo: downvoteButton.trailingAnchor, constant: 4),
            
            replyButton.centerYAnchor.constraint(equalTo: upvoteButton.centerYAnchor),
            replyButton.leadingAnchor.constraint(equalTo: downvoteCountLabel.trailingAnchor, constant: 12),
            
            reportButton.centerYAnchor.constraint(equalTo: upvoteButton.centerYAnchor),
            reportButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            reportButton.widthAnchor.constraint(equalToConstant: 25),
            reportButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupActions() {
        upvoteButton.addTarget(self, action: #selector(upvoteButtonTapped), for: .touchUpInside)
        downvoteButton.addTarget(self, action: #selector(downvoteButtonTapped), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(replyButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    func configure(with comment: Comment) {
        commentId = comment.id
        
        // Generate avatar initials and color
        let initials = generateAvatarInitials(from: comment.anonymousHandle)
        avatarLabel.text = initials
        avatarView.backgroundColor = generateAvatarColor(from: comment.anonymousHandle)
        
        // Set content
        handleLabel.text = "\(comment.anonymousHandle) • \(comment.timeAgo)"
        contentLabel.text = comment.content
        upvoteCountLabel.text = "\(comment.upvotes)"
        downvoteCountLabel.text = comment.downvotes > 0 ? "\(comment.downvotes)" : ""
        
        // Update vote button states
        updateVoteButtonStates(hasUserVoted: comment.hasUserVoted)
        
        // Hide reply button for now (can be implemented later for threaded comments)
        replyButton.isHidden = true
    }
    
    private func updateVoteButtonStates(hasUserVoted: Bool) {
        if hasUserVoted {
            upvoteButton.tintColor = UIColor.systemBlue
            upvoteCountLabel.textColor = UIColor.systemBlue
        } else {
            upvoteButton.tintColor = UIColor.systemGray
            upvoteCountLabel.textColor = UIColor.secondaryLabel
        }
    }
    
    // MARK: - Actions
    @objc private func upvoteButtonTapped() {
        delegate?.didTapUpvoteComment(for: commentId)
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func downvoteButtonTapped() {
        delegate?.didTapDownvoteComment(for: commentId)
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func reportButtonTapped() {
        delegate?.didTapReportComment(for: commentId)
    }
    
    @objc private func replyButtonTapped() {
        // Future implementation for threaded comments
        print("Reply tapped for comment: \(commentId)")
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
        // Generate consistent color based on handle hash
        let hash = handle.hashValue
        let colors: [UIColor] = [
            .systemBlue, .systemGreen, .systemIndigo,
            .systemOrange, .systemPurple, .systemRed,
            .systemTeal, .systemYellow, .systemPink,
            .systemCyan, .systemMint, .systemBrown
        ]
        let index = abs(hash) % colors.count
        return colors[index]
    }
    
    // MARK: - Animation
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.1) {
            self.containerView.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            self.containerView.alpha = highlighted ? 0.8 : 1.0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset state
        commentId = ""
        delegate = nil
        
        // Reset UI elements
        avatarLabel.text = ""
        avatarView.backgroundColor = UIColor.systemGray
        handleLabel.text = ""
        contentLabel.text = ""
        upvoteCountLabel.text = "0"
        downvoteCountLabel.text = ""
        
        // Reset button states
        upvoteButton.tintColor = UIColor.systemGray
        downvoteButton.tintColor = UIColor.systemGray
        upvoteCountLabel.textColor = UIColor.secondaryLabel
        downvoteCountLabel.textColor = UIColor.secondaryLabel
    }
}
