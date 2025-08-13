//
//  SceneDelegate.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/6/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Check if user is already logged in
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if isUserLoggedIn {
            // User is logged in, show main app with tab bar from storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController {
                // Add Profile tab programmatically
                addProfileTab(to: tabBarController)
                window?.rootViewController = tabBarController
            }
        } else {
            // User is not logged in, show welcome screen
            let welcomeVC = WelcomeViewController()
            let navigationController = UINavigationController(rootViewController: welcomeVC)
            window?.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
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

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}
