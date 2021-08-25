//
//  DataResponseError.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/20/21.
//

import Foundation


enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data "
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}
