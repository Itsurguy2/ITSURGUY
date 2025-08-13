//
//  CategoriesViewController.swift
//  ItsUrGuy
//
//  Created on [Date]
//  Copyright © 2024 ItsUrGuy. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var categories: [CategoryData] = []
    var filteredCategories: [CategoryData] = []
    var isSearching = false
    var selectedFilterType: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "All Topics"
        case trending = "Trending"
        case mostActive = "Most Active"
        case recent = "Recent Activity"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchBar()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh category data when returning to view
        loadCategories()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Discussion Topics"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup filter button
        filterButton.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        filterButton.target = self
        filterButton.action = #selector(filterButtonTapped)
    }
    
    private func setupTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        categoriesTableView.separatorStyle = .none
        categoriesTableView.backgroundColor = UIColor.systemGroupedBackground
        
        // Setup refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCategories), for: .valueChanged)
        categoriesTableView.refreshControl = refreshControl
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search topics..."
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor.clear
    }
    
    // MARK: - Data Loading
    private func loadCategories() {
        // Show loading indicator
        showLoadingIndicator()
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.categories = self.generateCategoryData()
            self.applyCurrentFilter()
            self.categoriesTableView.reloadData()
            self.hideLoadingIndicator()
            self.categoriesTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func generateCategoryData() -> [CategoryData] {
        return [
            CategoryData(
                category: .realTalk,
                postCount: 298,
                activeUsersCount: 45,
                trendingScore: 8.5,
                lastActivityTime: "2m ago",
                topPost: "Anyone else feeling like adulting is just making it up as you go?",
                isHot: true
            ),
            CategoryData(
                category: .workLife,
                postCount: 247,
                activeUsersCount: 38,
                trendingScore: 9.2,
                lastActivityTime: "5m ago",
                topPost: "Just got promoted but feeling major imposter syndrome...",
                isHot: true
            ),
            CategoryData(
                category: .relationships,
                postCount: 189,
                activeUsersCount: 29,
                trendingScore: 7.8,
                lastActivityTime: "8m ago",
                topPost: "How do you know when it's time to end a long relationship?",
                isHot: false
            ),
            CategoryData(
                category: .mentalHealth,
                postCount: 156,
                activeUsersCount: 52,
                trendingScore: 9.8,
                lastActivityTime: "1m ago",
                topPost: "Mental health check - how's everyone doing today?",
                isHot: true
            ),
            CategoryData(
                category: .moneyMoves,
                postCount: 134,
                activeUsersCount: 22,
                trendingScore: 6.9,
                lastActivityTime: "12m ago",
                topPost: "Side hustle ideas that actually worked for you?",
                isHot: false
            ),
            CategoryData(
                category: .sportsGaming,
                postCount: 112,
                activeUsersCount: 31,
                trendingScore: 7.2,
                lastActivityTime: "15m ago",
                topPost: "Anyone else think this season has been crazy?",
                isHot: false
            ),
            CategoryData(
                category: .healthFitness,
                postCount: 98,
                activeUsersCount: 18,
                trendingScore: 6.4,
                lastActivityTime: "20m ago",
                topPost: "Gym anxiety is real - how do you get over it?",
                isHot: false
            ),
            CategoryData(
                category: .currentEvents,
                postCount: 87,
                activeUsersCount: 15,
                trendingScore: 5.8,
                lastActivityTime: "25m ago",
                topPost: "What's everyone's take on the latest news?",
                isHot: false
            )
        ]
    }
    
    private func applyCurrentFilter() {
        switch selectedFilterType {
        case .all:
            filteredCategories = categories
        case .trending:
            filteredCategories = categories.filter { $0.isHot }.sorted { $0.trendingScore > $1.trendingScore }
        case .mostActive:
            filteredCategories = categories.sorted { $0.activeUsersCount > $1.activeUsersCount }
        case .recent:
            filteredCategories = categories.sorted { $0.lastActivityTime < $1.lastActivityTime }
        }
    }
    
    // MARK: - IBActions
    @objc private func filterButtonTapped() {
        showFilterOptions()
    }
    
    @objc private func refreshCategories() {
        loadCategories()
    }
    
    // MARK: - Helper Methods
    private func showLoadingIndicator() {
        DispatchQueue.main.async {
            // Add loading indicator
        }
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            // Remove loading indicator
        }
    }
    
    private func showFilterOptions() {
        let alert = UIAlertController(title: "Filter Topics", message: "Choose how to organize discussion topics", preferredStyle: .actionSheet)
        
        for filterType in FilterType.allCases {
            let action = UIAlertAction(title: filterType.rawValue, style: .default) { _ in
                self.selectedFilterType = filterType
                self.applyCurrentFilter()
                self.categoriesTableView.reloadData()
            }
            
            if filterType == selectedFilterType {
                action.setValue(true, forKey: "checked")
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = filterButton
        }
        
        present(alert, animated: true)
    }
    
    private func showCategoryAlert(for categoryData: CategoryData) {
        let alert = UIAlertController(
            title: categoryData.category.rawValue,
            message: "This category has \(categoryData.postCount) posts with \(categoryData.activeUsersCount) active users.\n\nTop post: \"\(categoryData.topPost)\"\n\n(Category detail view coming soon!)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Go to Home Feed", style: .default) { _ in
            // Switch to home tab
            self.tabBarController?.selectedIndex = 0
        })
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredCategories.count : filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        let categoryData = isSearching ? filteredCategories[indexPath.row] : filteredCategories[indexPath.row]
        
        cell.configure(with: categoryData)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let categoryData = isSearching ? filteredCategories[indexPath.row] : filteredCategories[indexPath.row]
        
        // Show alert with category info instead of navigating
        showCategoryAlert(for: categoryData)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UISearchBarDelegate
extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredCategories = categories
        } else {
            isSearching = true
            filteredCategories = categories.filter { categoryData in
                categoryData.category.rawValue.lowercased().contains(searchText.lowercased()) ||
                categoryData.topPost.lowercased().contains(searchText.lowercased())
            }
        }
        
        categoriesTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredCategories = categories
        categoriesTableView.reloadData()
    }
}

// MARK: - CategoryData Model
struct CategoryData {
    let category: PostCategory
    let postCount: Int
    let activeUsersCount: Int
    let trendingScore: Double
    let lastActivityTime: String
    let topPost: String
    let isHot: Bool
}

// MARK: - CategoryTableViewCell
class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let postCountBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor.systemBlue
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hotBadge: UILabel = {
        let label = UILabel()
        label.text = "🔥 HOT"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = UIColor.systemRed
        label.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = UIColor.systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(postCountBadge)
        containerView.addSubview(hotBadge)
        containerView.addSubview(activityLabel)
        containerView.addSubview(chevronImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Emoji
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 40),
            emojiLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: postCountBadge.leadingAnchor, constant: -8),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Hot badge
            hotBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            hotBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            hotBadge.widthAnchor.constraint(equalToConstant: 50),
            hotBadge.heightAnchor.constraint(equalToConstant: 20),
            
            // Post count badge
            postCountBadge.topAnchor.constraint(equalTo: hotBadge.bottomAnchor, constant: 4),
            postCountBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            postCountBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            postCountBadge.heightAnchor.constraint(equalToConstant: 24),
            
            // Activity label
            activityLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            activityLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // Chevron
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: postCountBadge.leadingAnchor, constant: -8),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    // MARK: - Configuration
    func configure(with categoryData: CategoryData) {
        emojiLabel.text = categoryData.category.emoji
        titleLabel.text = categoryData.category.rawValue
        subtitleLabel.text = categoryData.topPost
        postCountBadge.text = "\(categoryData.postCount)"
        activityLabel.text = "👥 \(categoryData.activeUsersCount) active • \(categoryData.lastActivityTime)"
        
        // Show/hide hot badge
        hotBadge.isHidden = !categoryData.isHot
        
        // Color code post count badge based on activity
        if categoryData.isHot {
            postCountBadge.backgroundColor = UIColor.systemRed
        } else if categoryData.activeUsersCount > 25 {
            postCountBadge.backgroundColor = UIColor.systemOrange
        } else {
            postCountBadge.backgroundColor = UIColor.systemBlue
        }
        
        // Update activity label color based on recency
        if categoryData.lastActivityTime.contains("m ago") {
            let minutes = Int(categoryData.lastActivityTime.components(separatedBy: "m").first ?? "0") ?? 0
            if minutes <= 5 {
                activityLabel.textColor = UIColor.systemGreen
            } else if minutes <= 15 {
                activityLabel.textColor = UIColor.systemOrange
            } else {
                activityLabel.textColor = UIColor.secondaryLabel
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.1) {
            self.containerView.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            self.containerView.alpha = highlighted ? 0.8 : 1.0
        }
    }
}
