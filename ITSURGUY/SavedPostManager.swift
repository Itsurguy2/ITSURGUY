//
//  SavedPostManager.swift
//  ITSURGUY
//
//  Created by Jesse Rosenthal on 8/13/25.
//



import Foundation

class SavedPostManager {
    static let shared = SavedPostManager()
    
    private let savedPostsKey = "savedPosts"
    
    private init() {}
    
    func getSavedPosts() -> [Post] {
        guard let data = UserDefaults.standard.data(forKey: "savedPosts") else {
            print("No saved posts found")
            return []
        }
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            print("Loaded \(posts.count) saved posts")
            return posts
        } catch {
            print("Error decoding posts: \(error)")
            return []
        }
    }

    func save(posts: [Post]) {
        do {
            let data = try JSONEncoder().encode(posts)
            UserDefaults.standard.set(data, forKey: "savedPosts")
            print("Saved \(posts.count) posts successfully")
        } catch {
            print("Error encoding posts: \(error)")
        }
    }

    
    func savePost(_ post: Post) {
        var current = getSavedPosts()
        if !current.contains(where: { $0.id == post.id }) {
            current.append(post)
            save(posts: current)
            print("Post saved!")
        } else {
            print("Post already saved.")
        }
    }

    
    func unsave(post: Post) {
        var current = getSavedPosts()
        current.removeAll { $0.id == post.id }
        save(posts: current)
    }
    
    private func notSaved(posts: [Post]) {
        do {
            let data = try JSONEncoder().encode(posts)
            UserDefaults.standard.set(data, forKey: savedPostsKey)
        } catch {
            print("❌ Failed to encode posts:", error)
        }
    }
    
    func isPostSaved(_ post: Post) -> Bool {
        return getSavedPosts().contains { $0.id == post.id }
    }
}

