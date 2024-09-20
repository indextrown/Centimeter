//
//  UserDefaultsHelper.swift
//  Centimeter
//
//  Created by 김동현 on 9/20/24.
//

import Foundation

class UserDefaultsHelper {
    private let postsKey = "postsKey"
    
    func savePosts(_ posts: [Post]) {
        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(encoded, forKey: postsKey)
        }
    }
    
    func loadPosts() -> [Post] {
        if let data = UserDefaults.standard.data(forKey: postsKey),
           let decodedPosts = try? JSONDecoder().decode([Post].self, from: data) {
            return decodedPosts
        }
        return []
    }
}

