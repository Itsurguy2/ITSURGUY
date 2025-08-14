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
        let editProfileVC = EditProfileViewController()
        let navController = UINavigationController(rootViewController: editProfileVC)
        present(navController, animated: true)
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
            // Create a simple posts list view controller
            let myPostsVC = MyPostsViewController()
            navigationController?.pushViewController(myPostsVC, animated: true)
        }
        
        private func navigateToSavedPosts() {
            let savedPostsVC = SavedPostsViewController()
            navigationController?.pushViewController(savedPostsVC, animated: true)
        }
        
        private func navigateToNotifications() {
            let notificationsVC = NotificationSettingsViewController()
            navigationController?.pushViewController(notificationsVC, animated: true)
        }
        
        private func navigateToPrivacy() {
            let privacyVC = PrivacySettingsViewController()
            navigationController?.pushViewController(privacyVC, animated: true)
        }
        
        private func navigateToHelp() {
            // Navigate to the existing ResourcesViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let resourcesVC = storyboard.instantiateViewController(withIdentifier: "ResourcesViewController") as? ResourcesViewController {
                navigationController?.pushViewController(resourcesVC, animated: true)
            } else {
                // Fallback: create programmatically
                let resourcesVC = ResourcesViewController()
                navigationController?.pushViewController(resourcesVC, animated: true)
            }
        }
        
        private func navigateToAbout() {
            let aboutVC = AboutViewController()
            navigationController?.pushViewController(aboutVC, animated: true)
        }
    }
    
    
// MARK: - Simple ResourcesViewController (Programmatic)
class SimpleResourcesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Help & Safety"
        view.backgroundColor = .systemGroupedBackground
        
        setupUI()
    }
    
    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Crisis Section
        let crisisLabel = UILabel()
        crisisLabel.text = "🆘 Crisis Resources"
        crisisLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        crisisLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let crisisButton = UIButton(type: .system)
        crisisButton.setTitle("Call 988 - Suicide Prevention", for: .normal)
        crisisButton.backgroundColor = .systemRed
        crisisButton.setTitleColor(.white, for: .normal)
        crisisButton.layer.cornerRadius = 8
        crisisButton.translatesAutoresizingMaskIntoConstraints = false
        crisisButton.addTarget(self, action: #selector(callCrisis), for: .touchUpInside)
        
        let textCrisisButton = UIButton(type: .system)
        textCrisisButton.setTitle("Text 741741 - Crisis Text Line", for: .normal)
        textCrisisButton.backgroundColor = .systemBlue
        textCrisisButton.setTitleColor(.white, for: .normal)
        textCrisisButton.layer.cornerRadius = 8
        textCrisisButton.translatesAutoresizingMaskIntoConstraints = false
        textCrisisButton.addTarget(self, action: #selector(textCrisis), for: .touchUpInside)
        
        // Mental Health Section
        let mentalHealthLabel = UILabel()
        mentalHealthLabel.text = "🧠 Mental Health Support"
        mentalHealthLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        mentalHealthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "• SAMHSA Helpline: 1-800-662-4357\n• BetterHelp: Online therapy\n• Crisis Text Line: Text HOME to 741741\n• Veterans Crisis Line: 1-800-273-8255"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(crisisLabel)
        contentView.addSubview(crisisButton)
        contentView.addSubview(textCrisisButton)
        contentView.addSubview(mentalHealthLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            crisisLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            crisisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            crisisLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            crisisButton.topAnchor.constraint(equalTo: crisisLabel.bottomAnchor, constant: 16),
            crisisButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            crisisButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            crisisButton.heightAnchor.constraint(equalToConstant: 50),
            
            textCrisisButton.topAnchor.constraint(equalTo: crisisButton.bottomAnchor, constant: 12),
            textCrisisButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textCrisisButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textCrisisButton.heightAnchor.constraint(equalToConstant: 50),
            
            mentalHealthLabel.topAnchor.constraint(equalTo: textCrisisButton.bottomAnchor, constant: 30),
            mentalHealthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mentalHealthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: mentalHealthLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    @objc private func callCrisis() {
        if let phoneURL = URL(string: "tel://988") {
            UIApplication.shared.open(phoneURL)
        }
    }
    
    @objc private func textCrisis() {
        if let messageURL = URL(string: "sms://741741") {
            UIApplication.shared.open(messageURL)
        }
    }
}

