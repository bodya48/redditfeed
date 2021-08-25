//
//  Result.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/20/21.
//

import Foundation

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
