//
//  PrivacySettingsViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/13/25.
//

import UIKit
import Foundation

class PrivacySettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy & Security"
        view.backgroundColor = .systemGroupedBackground
        
        let label = UILabel()
        label.text = "Privacy settings coming soon!"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
