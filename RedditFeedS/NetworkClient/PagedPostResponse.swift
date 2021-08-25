//
//  PagedPostResponse.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/20/21.
//

import Foundation


struct PagedPostResponse {
    
    var afterLink: String?
    var numberItemsPerPage = 0
    var posts = [Post]()
    var hasMore = false
    
    
    init(from json: [String: Any]) {
        
        guard let data = json["data"] as? [String: Any] else {
            return
        }
        
        if let afterLink = data["after"] as? String {
            self.afterLink = afterLink
            self.hasMore = true
        }
        if let itemsNumber = data["dist"] as? Int {
            self.numberItemsPerPage = itemsNumber
        }
        
        if let children = data["children"] as? [Any] {
            for item in children {
                let postItem = item as! [String: Any]
                
                let post = Post(from: postItem)
                self.posts.append(post)
            }
        }
    }
}
