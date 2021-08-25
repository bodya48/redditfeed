//
//  HTTPURLResponse.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/20/21.
//

import Foundation


extension HTTPURLResponse {
    
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
