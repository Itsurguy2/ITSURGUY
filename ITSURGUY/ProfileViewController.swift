//
//  ProfileViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/8/25.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let memberSinceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(editProfileTapped), for: .touchUpInside)
        return button
    }()
    
    private let settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(signOutTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private let settingsOptions = [
        ["My Posts", "Your Saved Posts", "Notifications"],
        ["Privacy & Security", "Help & Support", "About ITSURGUY"]
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(memberSinceLabel)
        contentView.addSubview(statsStackView)
        contentView.addSubview(editProfileButton)
        contentView.addSubview(settingsTableView)
        contentView.addSubview(signOutButton)
        
        setupStatsView()
        setupTableView()
    }
    
    private func setupStatsView() {
        let postsView = createStatView(title: "Posts", value: "12")
        let helpedView = createStatView(title: "Helped", value: "48")
        let supportView = createStatView(title: "Support", value: "156")
        
        statsStackView.addArrangedSubview(postsView)
        statsStackView.addArrangedSubview(helpedView)
        statsStackView.addArrangedSubview(supportView)
    }
    
    private func createStatView(title: String, value: String) -> UIView {
        let container = UIView()
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(valueLabel)
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: container.topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func setupTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    private func setupConstraints() {
        // Calculate table view height
        let rowHeight: CGFloat = 44
        let headerHeight: CGFloat = 35
        let totalRows = settingsOptions.reduce(0) { $0 + $1.count }
        let totalHeight = CGFloat(totalRows) * rowHeight + CGFloat(settingsOptions.count) * headerHeight + 60
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Email Label
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Member Since Label
            memberSinceLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            memberSinceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            memberSinceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Stats Stack View
            statsStackView.topAnchor.constraint(equalTo: memberSinceLabel.bottomAnchor, constant: 30),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            statsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            // Edit Profile Button
            editProfileButton.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 30),
            editProfileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            editProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            editProfileButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Settings Table View
            settingsTableView.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 30),
            settingsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: totalHeight),
            
            // Sign Out Button
            signOutButton.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: 20),
            signOutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signOutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func loadUserData() {
        // Load user data from UserDefaults
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "ITSURGUY User"
        let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "user@itsurguy.com"
        
        nameLabel.text = userName
        emailLabel.text = userEmail
        
        // Set member since date
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        memberSinceLabel.text = "Member since \(formatter.string(from: Date()))"
    }
    
    // MARK: - Actions
    @objc private func editProfileTapped() {
        // TODO: Navigate to edit profile screen
        print("Edit Profile tapped")
    }
    
    @objc private func signOutTapped() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            self.performSignOut()
        })
        
        present(alert, animated: true)
    }
    
    private func performSignOut() {
        // Clear user data
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        // Navigate back to welcome screen
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let welcomeVC = WelcomeViewController()
            let navigationController = UINavigationController(rootViewController: welcomeVC)
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
            }, completion: nil)
            
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settingsOptions[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let option = settingsOptions[indexPath.section][indexPath.row]
        
        switch option {
        case "My Posts":
            navigateToMyPosts()
        case "Your Saved Posts":
            navigateToSavedPosts()
        case "Notifications":
            navigateToNotifications()
        case "Privacy & Security":
            navigateToPrivacy()
        case "Help & Support":
            navigateToHelp()
        case "About ITSURGUY":
            navigateToAbout()
        default:
            break
        }
    }
    
    private func navigateToMyPosts() {
        // Navigate to user's posts
        print("Navigate to My Posts")
    }
    
    private func navigateToSavedPosts() {
        // Navigate to saved posts
        print("Navigate to Saved Posts")
    }
    
    private func navigateToNotifications() {
        // Navigate to notifications settings
        print("Navigate to Notifications")
    }
    
    private func navigateToPrivacy() {
        // Navigate to privacy settings
        print("Navigate to Privacy & Security")
    }
    
    private func navigateToHelp() {
        // Navigate to help & support
        print("Navigate to Help & Support")
    }
    
    private func navigateToAbout() {
        // Navigate to about page
        print("Navigate to About ITSURGUY")
    }
}
