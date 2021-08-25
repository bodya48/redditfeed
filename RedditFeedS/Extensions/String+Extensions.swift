//
//  String.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/24/21.
//

import Foundation

extension String {
    
    var isValidURL: Bool {
        get {
            let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
            let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
            return predicate.evaluate(with: self)
        }
    }
}
