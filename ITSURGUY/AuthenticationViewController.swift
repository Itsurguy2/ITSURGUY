//
//  AuthenticationViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/8/25.
//
import UIKit

class AuthenticationViewController: UIViewController {
    
    enum AuthMode {
        case signIn
        case signUp
    }
    
    // MARK: - Properties
    var initialMode: AuthMode = .signUp
    private var currentMode: AuthMode = .signUp {
        didSet {
            updateUIForMode()
        }
    }
    
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
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full Name"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let toggleModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(toggleModeTapped), for: .touchUpInside)
        return button
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Google", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(googleSignInTapped), for: .touchUpInside)
        return button
    }()
    
    private let appleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Apple", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(appleSignInTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMode = initialMode
        setupUI()
        setupConstraints()
        setupKeyboardHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(actionButton)
        contentView.addSubview(toggleModeButton)
        contentView.addSubview(orLabel)
        contentView.addSubview(googleSignInButton)
        contentView.addSubview(appleSignInButton)
        
        updateUIForMode()
    }
    
    private func setupConstraints() {
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
            
            // Back Button
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            // Name TextField
            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password TextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Confirm Password TextField
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Action Button
            actionButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Toggle Mode Button
            toggleModeButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            toggleModeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Or Label
            orLabel.topAnchor.constraint(equalTo: toggleModeButton.bottomAnchor, constant: 30),
            orLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Google Sign In Button
            googleSignInButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20),
            googleSignInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            googleSignInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Apple Sign In Button
            appleSignInButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 12),
            appleSignInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            appleSignInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 50),
            appleSignInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func updateUIForMode() {
        switch currentMode {
        case .signIn:
            titleLabel.text = "Welcome Back"
            subtitleLabel.text = "Sign in to continue to ITSURGUY"
            actionButton.setTitle("Sign In", for: .normal)
            toggleModeButton.setTitle("Don't have an account? Sign Up", for: .normal)
            nameTextField.isHidden = true
            confirmPasswordTextField.isHidden = true
            
        case .signUp:
            titleLabel.text = "Create Account"
            subtitleLabel.text = "Join the ITSURGUY community"
            actionButton.setTitle("Sign Up", for: .normal)
            toggleModeButton.setTitle("Already have an account? Sign In", for: .normal)
            nameTextField.isHidden = false
            confirmPasswordTextField.isHidden = false
        }
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func actionButtonTapped() {
        // Validate input
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all required fields")
            return
        }
        
        if currentMode == .signUp {
            guard let name = nameTextField.text, !name.isEmpty,
                  let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
                showAlert(title: "Error", message: "Please fill in all required fields")
                return
            }
            
            guard password == confirmPassword else {
                showAlert(title: "Error", message: "Passwords do not match")
                return
            }
            
            // TODO: Implement sign up logic here
            print("Sign Up: \(name), \(email)")
        } else {
            // TODO: Implement sign in logic here
            print("Sign In: \(email)")
        }
        
        // For now, just navigate to main app
        navigateToMainApp()
    }
    
    @objc private func toggleModeTapped() {
        currentMode = currentMode == .signIn ? .signUp : .signIn
    }
    
    @objc private func googleSignInTapped() {
        // TODO: Implement Google Sign In
        print("Google Sign In tapped")
        navigateToMainApp()
    }
    
    @objc private func appleSignInTapped() {
        // TODO: Implement Apple Sign In
        print("Apple Sign In tapped")
        navigateToMainApp()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            // Updated for iOS 13+
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        // Updated for iOS 13+
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToMainApp() {
        // Save login state
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        
        // Save user info if sign up
        if currentMode == .signUp {
            UserDefaults.standard.set(nameTextField.text, forKey: "userName")
        }
        UserDefaults.standard.set(emailTextField.text, forKey: "userEmail")
        
        // Navigate to main tab bar controller from storyboard
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            // Load the tab bar controller from storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController {
                // Add Profile tab programmatically
                addProfileTab(to: tabBarController)
                
                // Set it as root with animation
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = tabBarController
                }, completion: nil)
                
                window.makeKeyAndVisible()
            }
        }
    }
    
    private func addProfileTab(to tabBarController: UITabBarController) {
        // Create Profile tab
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        
        // Add Profile tab to existing tabs
        var viewControllers = tabBarController.viewControllers ?? []
        viewControllers.append(profileNav)
        tabBarController.viewControllers = viewControllers
    }
}
