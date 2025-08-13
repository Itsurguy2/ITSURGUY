//
//   ResourcesViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/6/25.
//

import UIKit

class ResourcesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var crisisContainerView: UIView!
    @IBOutlet weak var crisisCallButton: UIButton!
    @IBOutlet weak var crisisTextButton: UIButton!
    @IBOutlet weak var emergencyContactsButton: UIButton!
    @IBOutlet weak var resourcesTableView: UITableView!
    @IBOutlet weak var resourcesTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    // MARK: - Properties
    private var resources: [ResourceCategory] = []
    
    struct ResourceCategory {
        let title: String
        let items: [ResourceItem]
    }
    
    struct ResourceItem {
        let title: String
        let description: String
        let phoneNumber: String?
        let website: String?
        let icon: String
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadResources()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Help & Safety"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup crisis container
        crisisContainerView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        crisisContainerView.layer.cornerRadius = 12
        crisisContainerView.layer.borderWidth = 2
        crisisContainerView.layer.borderColor = UIColor.systemRed.cgColor
        
        // Setup crisis buttons
        crisisCallButton.layer.cornerRadius = 8
        crisisTextButton.layer.cornerRadius = 8
        
        // Setup emergency contacts button
        emergencyContactsButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func setupTableView() {
        resourcesTableView.delegate = self
        resourcesTableView.dataSource = self
        resourcesTableView.register(ResourceTableViewCell.self, forCellReuseIdentifier: "ResourceCell")
        resourcesTableView.separatorStyle = .none
        resourcesTableView.isScrollEnabled = false
        resourcesTableView.backgroundColor = .clear
    }
    
    private func loadResources() {
        resources = [
            ResourceCategory(title: "Mental Health Support", items: [
                ResourceItem(
                    title: "SAMHSA National Helpline",
                    description: "Free, confidential, 24/7 treatment referral and information service",
                    phoneNumber: "1-800-662-4357",
                    website: "https://www.samhsa.gov",
                    icon: "🧠"
                ),
                ResourceItem(
                    title: "BetterHelp",
                    description: "Online therapy and counseling services",
                    phoneNumber: nil,
                    website: "https://www.betterhelp.com",
                    icon: "💬"
                ),
                ResourceItem(
                    title: "Therapy for Black Men",
                    description: "Directory of therapists committed to the mental health of Black men",
                    phoneNumber: nil,
                    website: "https://therapyforblackmen.org",
                    icon: "🤝"
                )
            ]),
            ResourceCategory(title: "Crisis Prevention", items: [
                ResourceItem(
                    title: "988 Suicide & Crisis Lifeline",
                    description: "24/7 free and confidential support for people in distress",
                    phoneNumber: "988",
                    website: "https://988lifeline.org",
                    icon: "🆘"
                ),
                ResourceItem(
                    title: "Crisis Text Line",
                    description: "Text HOME to 741741 for free crisis counseling",
                    phoneNumber: "741741",
                    website: "https://www.crisistextline.org",
                    icon: "💬"
                ),
                ResourceItem(
                    title: "Veterans Crisis Line",
                    description: "Support for Veterans and their loved ones",
                    phoneNumber: "1-800-273-8255",
                    website: "https://www.veteranscrisisline.net",
                    icon: "🎖️"
                )
            ]),
            ResourceCategory(title: "Substance Abuse", items: [
                ResourceItem(
                    title: "SAMHSA Treatment Locator",
                    description: "Find treatment facilities and programs",
                    phoneNumber: "1-800-662-4357",
                    website: "https://findtreatment.samhsa.gov",
                    icon: "🏥"
                ),
                ResourceItem(
                    title: "Alcoholics Anonymous",
                    description: "Support groups for alcohol addiction recovery",
                    phoneNumber: nil,
                    website: "https://www.aa.org",
                    icon: "🤲"
                ),
                ResourceItem(
                    title: "SMART Recovery",
                    description: "Self-help addiction recovery support groups",
                    phoneNumber: nil,
                    website: "https://www.smartrecovery.org",
                    icon: "💪"
                )
            ]),
            ResourceCategory(title: "Financial Help", items: [
                ResourceItem(
                    title: "National Foundation for Credit Counseling",
                    description: "Free financial counseling and debt management",
                    phoneNumber: "1-800-388-2227",
                    website: "https://www.nfcc.org",
                    icon: "💰"
                ),
                ResourceItem(
                    title: "211 Helpline",
                    description: "Connect with local resources for food, housing, and more",
                    phoneNumber: "211",
                    website: "https://www.211.org",
                    icon: "📞"
                )
            ])
        ]
        
        resourcesTableView.reloadData()
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        resourcesTableView.layoutIfNeeded()
        let height = CGFloat(resources.reduce(0) { $0 + $1.items.count }) * 100 + CGFloat(resources.count) * 50
        resourcesTableViewHeightConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    @IBAction func callCrisisHotline() {
        if let phoneURL = URL(string: "tel://988") {
            UIApplication.shared.open(phoneURL)
        }
    }
    
    @IBAction func textCrisisLine() {
        if let messageURL = URL(string: "sms://741741") {
            UIApplication.shared.open(messageURL)
        }
    }
    
    @IBAction func showEmergencyContacts() {
        showEmergencyContactsAlert()
    }
    
    @IBAction func settingsButtonTapped() {
        showSettingsAlert()
    }
    
    // MARK: - Helper Methods
    private func showEmergencyContactsAlert() {
        let alert = UIAlertController(
            title: "Emergency Resources",
            message: "Choose an emergency service to contact",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "911 - Emergency Services", style: .default) { _ in
            if let phoneURL = URL(string: "tel://911") {
                UIApplication.shared.open(phoneURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "988 - Suicide Prevention", style: .default) { _ in
            if let phoneURL = URL(string: "tel://988") {
                UIApplication.shared.open(phoneURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "741741 - Crisis Text Line", style: .default) { _ in
            if let messageURL = URL(string: "sms://741741") {
                UIApplication.shared.open(messageURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = emergencyContactsButton
            popover.sourceRect = emergencyContactsButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Settings",
            message: "Configure your safety preferences",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Crisis Detection Settings", style: .default) { _ in
            self.showCrisisDetectionSettings()
        })
        
        alert.addAction(UIAlertAction(title: "Notification Preferences", style: .default) { _ in
            self.showNotificationSettings()
        })
        
        alert.addAction(UIAlertAction(title: "Privacy & Safety", style: .default) { _ in
            self.showPrivacySettings()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = settingsButton
        }
        
        present(alert, animated: true)
    }
    
    private func showCrisisDetectionSettings() {
        let alert = UIAlertController(
            title: "Crisis Detection",
            message: "We monitor posts for crisis keywords to provide immediate help when needed. This feature is always on for user safety.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showNotificationSettings() {
        let alert = UIAlertController(
            title: "Notifications",
            message: "Manage when you receive alerts and updates",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showPrivacySettings() {
        let alert = UIAlertController(
            title: "Privacy & Safety",
            message: "All posts are anonymous. Your identity is never shared.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ResourcesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return resources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceTableViewCell
        let resource = resources[indexPath.section].items[indexPath.row]
        cell.configure(with: resource)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return resources[section].title
    }
}

// MARK: - UITableViewDelegate
extension ResourcesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let resource = resources[indexPath.section].items[indexPath.row]
        showResourceDetail(resource)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    private func showResourceDetail(_ resource: ResourceItem) {
        let alert = UIAlertController(
            title: resource.title,
            message: resource.description,
            preferredStyle: .alert
        )
        
        if let phone = resource.phoneNumber {
            alert.addAction(UIAlertAction(title: "Call \(phone)", style: .default) { _ in
                if let phoneURL = URL(string: "tel://\(phone.replacingOccurrences(of: "-", with: ""))") {
                    UIApplication.shared.open(phoneURL)
                }
            })
        }
        
        if let website = resource.website {
            alert.addAction(UIAlertAction(title: "Visit Website", style: .default) { _ in
                if let url = URL(string: website) {
                    UIApplication.shared.open(url)
                }
            })
        }
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - ResourceTableViewCell
class ResourceTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = UIColor.systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            iconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func configure(with resource: ResourcesViewController.ResourceItem) {
        iconLabel.text = resource.icon
        titleLabel.text = resource.title
        descriptionLabel.text = resource.description
    }
}
