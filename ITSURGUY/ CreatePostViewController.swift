//
//   CreatePostViewController.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/6/25.
//


import UIKit

class CreatePostViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var triggerWarningSwitch: UISwitch!
    @IBOutlet weak var triggerWarningLabel: UILabel!
    @IBOutlet weak var crisisDetectionView: UIView!
    @IBOutlet weak var crisisHelpButton: UIButton!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - Properties
    private let maxCharacterCount = 500
    private var selectedCategory: PostCategory = .realTalk
    private var hasPhoto = false
    private var crisisKeywords = ["suicide", "kill myself", "end it all", "hurt myself", "can't go on", "no point", "want to die"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextView()
        checkCrisisDetection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postContentTextView.becomeFirstResponder()
    }
    
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "New Post"
        
        // Setup navigation buttons
        postButton.isEnabled = false
        
        // Setup category segmented control
        setupCategorySegmentedControl()
        
        // Setup trigger warning
        triggerWarningLabel.text = "Content Warning"
        triggerWarningSwitch.isOn = false
        
        // Setup crisis detection view
        crisisDetectionView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        crisisDetectionView.layer.cornerRadius = 8
        crisisDetectionView.isHidden = true
        
        crisisHelpButton.setTitle("Get Immediate Help", for: .normal)
        crisisHelpButton.backgroundColor = UIColor.systemRed
        crisisHelpButton.setTitleColor(.white, for: .normal)
        crisisHelpButton.layer.cornerRadius = 8
        
        // Setup add photo button
        addPhotoButton.setTitle("📸 Add Anonymous Photo", for: .normal)
        addPhotoButton.backgroundColor = UIColor.secondarySystemGroupedBackground
        addPhotoButton.setTitleColor(UIColor.systemBlue, for: .normal)
        addPhotoButton.layer.cornerRadius = 8
        addPhotoButton.layer.borderWidth = 1
        addPhotoButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        // Character count
        updateCharacterCount()
    }
    
    private func setupCategorySegmentedControl() {
        categorySegmentedControl.removeAllSegments()
        
        let mainCategories: [PostCategory] = [.realTalk, .workLife, .mentalHealth, .relationships]
        
        for (index, category) in mainCategories.enumerated() {
            categorySegmentedControl.insertSegment(withTitle: "\(category.emoji) \(category.rawValue)", at: index, animated: false)
        }
        
        categorySegmentedControl.selectedSegmentIndex = 0
        categorySegmentedControl.addTarget(self, action: #selector(categoryChanged(_:)), for: .valueChanged)
    }
    
    private func setupTextView() {
        postContentTextView.delegate = self
        postContentTextView.font = UIFont.systemFont(ofSize: 16)
        postContentTextView.layer.cornerRadius = 8
        postContentTextView.layer.borderWidth = 1
        postContentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        postContentTextView.text = "What's on your mind? Keep it real..."
        postContentTextView.textColor = UIColor.placeholderText
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if !postContentTextView.text.isEmpty && postContentTextView.textColor != UIColor.placeholderText {
            showDiscardConfirmation()
        } else {
            dismiss(animated: true)
        }
    }
    
    @IBAction func postButtonTapped(_ sender: UIBarButtonItem) {
        createPost()
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        showPhotoOptions()
    }
    
    @IBAction func crisisHelpButtonTapped(_ sender: UIButton) {
        showCrisisResources()
    }
    
    @objc private func categoryChanged(_ sender: UISegmentedControl) {
        let categories: [PostCategory] = [.realTalk, .workLife, .mentalHealth, .relationships]
        selectedCategory = categories[sender.selectedSegmentIndex]
    }
    
    // MARK: - Helper Methods
    private func updateCharacterCount() {
        let currentCount = postContentTextView.textColor == UIColor.placeholderText ? 0 : postContentTextView.text.count
        characterCountLabel.text = "\(currentCount)/\(maxCharacterCount)"
        
        if currentCount > maxCharacterCount {
            characterCountLabel.textColor = UIColor.systemRed
        } else if currentCount > maxCharacterCount - 50 {
            characterCountLabel.textColor = UIColor.systemOrange
        } else {
            characterCountLabel.textColor = UIColor.secondaryLabel
        }
        
        // Enable/disable post button - FIXED LOGIC
        let hasValidText = postContentTextView.textColor != UIColor.placeholderText &&
                          !postContentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                          currentCount > 0 && currentCount <= maxCharacterCount
        
        postButton.isEnabled = hasValidText
        
        print("DEBUG: Text count: \(currentCount), hasValidText: \(hasValidText), button enabled: \(postButton.isEnabled)")
    }
    
    private func checkCrisisDetection() {
        let text = postContentTextView.text.lowercased()
        let containsCrisisKeyword = crisisKeywords.contains { keyword in
            text.contains(keyword)
        }
        
        if containsCrisisKeyword {
            showCrisisDetectionAlert()
            crisisDetectionView.isHidden = false
        } else {
            crisisDetectionView.isHidden = true
        }
    }
    
    private func showCrisisDetectionAlert() {
        let alert = UIAlertController(
            title: "We're Here for You",
            message: "It sounds like you might be going through a tough time. You're not alone, and help is available. Would you like to speak with someone right now?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Call Crisis Hotline", style: .default) { _ in
            self.callCrisisHotline()
        })
        
        alert.addAction(UIAlertAction(title: "Text Crisis Line", style: .default) { _ in
            self.openCrisisTextLine()
        })
        
        alert.addAction(UIAlertAction(title: "Continue Posting", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func callCrisisHotline() {
        if let phoneURL = URL(string: "tel://988") {
            UIApplication.shared.open(phoneURL)
        }
    }
    
    private func openCrisisTextLine() {
        if let messageURL = URL(string: "sms://741741") {
            UIApplication.shared.open(messageURL)
        }
    }
    
    private func showCrisisResources() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resourcesVC = storyboard.instantiateViewController(withIdentifier: "ResourcesViewController") as? ResourcesViewController {
            let navController = UINavigationController(rootViewController: resourcesVC)
            present(navController, animated: true)
        }
    }
    
    private func showDiscardConfirmation() {
        let alert = UIAlertController(
            title: "Discard Post?",
            message: "Are you sure you want to discard this post? Your changes will be lost.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.dismiss(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showPhotoOptions() {
        let alert = UIAlertController(
            title: "Add Photo",
            message: "All photos are automatically anonymized by removing metadata.",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        })
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.openPhotoLibrary()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = addPhotoButton
            popover.sourceRect = addPhotoButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func openCamera() {
        // Implementation for camera access
        print("Opening camera...")
        // Note: In real implementation, you'd use UIImagePickerController
        simulatePhotoAdded()
    }
    
    private func openPhotoLibrary() {
        // Implementation for photo library access
        print("Opening photo library...")
        // Note: In real implementation, you'd use UIImagePickerController
        simulatePhotoAdded()
    }
    
    private func simulatePhotoAdded() {
        hasPhoto = true
        addPhotoButton.setTitle("📸 Photo Added (Anonymous)", for: .normal)
        addPhotoButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        addPhotoButton.setTitleColor(UIColor.systemGreen, for: .normal)
        addPhotoButton.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    private func createPost() {
        // Check if we have valid content
        guard postContentTextView.textColor != UIColor.placeholderText,
              !postContentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("ERROR: No valid content to post")
            return
        }
        
        print("DEBUG: Creating post with content: \(postContentTextView.text!)")
        
        // Show loading indicator
        postButton.isEnabled = false
        postButton.title = "Posting..."
        
        let content = postContentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create post object
        let newPost = Post(
            id: UUID().uuidString,
            anonymousHandle: "Anonymous Guy #\(Int.random(in: 100...999))",
            content: content,
            category: selectedCategory,
            upvotes: 0,
            downvotes: 0,
            commentCount: 0,
            timeAgo: "now",
            hasUserVoted: false,
            imageUrl: hasPhoto ? "anonymous_image_url" : nil,
            isReported: false,
            hasTriggerWarning: triggerWarningSwitch.isOn
        )
        
        print("DEBUG: Created post object: \(newPost)")
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Post creation successful
            print("DEBUG: Post creation completed")
            
            // Reset button
            self.postButton.isEnabled = true
            self.postButton.title = "Post"
            
            // Show success message
            self.showSuccessMessage()
            
            // Post notification to refresh home feed
            NotificationCenter.default.post(name: NSNotification.Name("PostCreated"), object: newPost)
            
            // Clear the form
            self.clearForm()
            
            // Dismiss or navigate back
            if self.navigationController?.viewControllers.count ?? 0 > 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    private func clearForm() {
        postContentTextView.text = "What's on your mind? Keep it real..."
        postContentTextView.textColor = UIColor.placeholderText
        triggerWarningSwitch.isOn = false
        hasPhoto = false
        addPhotoButton.setTitle("📸 Add Anonymous Photo", for: .normal)
        addPhotoButton.backgroundColor = UIColor.secondarySystemGroupedBackground
        addPhotoButton.setTitleColor(UIColor.systemBlue, for: .normal)
        addPhotoButton.layer.borderColor = UIColor.systemBlue.cgColor
        updateCharacterCount()
    }
    
    private func showSuccessMessage() {
        let alert = UIAlertController(
            title: "Post Created!",
            message: "Your anonymous post has been shared with the community.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CreatePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = ""
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's on your mind? Keep it real..."
            textView.textColor = UIColor.placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
        checkCrisisDetection()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= maxCharacterCount
    }
}

// MARK: - Extensions for Crisis Detection
extension CreatePostViewController {
    
    private func performAdvancedCrisisDetection(_ text: String) -> Bool {
        // More sophisticated crisis detection
        let lowercaseText = text.lowercased()
        
        // Check for crisis phrases
        let crisisPhrases = [
            "want to die",
            "kill myself",
            "end my life",
            "can't go on",
            "no point living",
            "hurt myself",
            "end it all",
            "better off dead",
            "no way out"
        ]
        
        let containsCrisisPhrase = crisisPhrases.contains { phrase in
            lowercaseText.contains(phrase)
        }
        
        // Check for concerning word combinations
        let suicidalWords = ["suicide", "suicidal", "die", "death", "kill", "end"]
        let negativeWords = ["can't", "won't", "no", "never", "impossible", "hopeless"]
        
        let containsSuicidalWord = suicidalWords.contains { word in
            lowercaseText.contains(word)
        }
        
        let containsNegativeWord = negativeWords.contains { word in
            lowercaseText.contains(word)
        }
        
        return containsCrisisPhrase || (containsSuicidalWord && containsNegativeWord)
    }
}
