//
//  Post.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/20/21.
//

import Foundation


struct Post {
    
    var title: String?
    var score: Int?
    var commentsNumber: Int?
    var thumbnail: String?
    var thumbnail_width: Float?
    var thumbnail_height: Float?
    
    
    init(from json: [String: Any]) {
        
        guard let data = json["data"] as? [String: Any] else {
            return
        }
        
        if let title = data["title"] as? String {
            self.title = title
        }
        if let score = data["score"] as? Int {
            self.score = score
        }
        if let comments = data["num_comments"] as? Int {
            self.commentsNumber = comments
        }
        
        if let thumbnail = data["thumbnail"] as? String {
            if thumbnail.isValidURL {
                self.thumbnail = thumbnail
            }
        }
        if let thumbnail_width = data["thumbnail_width"] as? Float {
            self.thumbnail_width = thumbnail_width
        }
        if let thumbnail_height = data["thumbnail_height"] as? Float {
            self.thumbnail_height = thumbnail_height
        }
    }
}
