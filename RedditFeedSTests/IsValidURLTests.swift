//
//  IsValidURLTests.swift
//  RedditFeedSTests
//
//  Created by Bogdan Laukhin on 8/25/21.
//

import XCTest
@testable import RedditFeedS


class IsValidURLTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    
    func test_url_is_valid() throws {
        let url = "https://www.google.com"
        XCTAssertTrue(url.isValidURL)
    }
    
    
    func test_url_is_invalid() throws {
        let url = "some.com.url"
        XCTAssertFalse(url.isValidURL)
    }
}
