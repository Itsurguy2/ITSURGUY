//
//  SavedPostsViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/13/25.
//

import UIKit
import Foundation

class SavedPostsViewController: UIViewController {
    private let tableView = UITableView()
    private var savedPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Posts"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        loadSavedPosts()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadSavedPosts() {
        savedPosts = SavedPostManager.shared.getSavedPosts()
        tableView.reloadData()
        
        if savedPosts.isEmpty {
            showEmptyState()
        }
    }

    
    private func showEmptyState() {
        let emptyLabel = UILabel()
        emptyLabel.text = "No saved posts yet.\nSave posts to view them here!"
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

extension SavedPostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.configure(with: savedPosts[indexPath.row])
        return cell
    }
}
