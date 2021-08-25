//
//  PagedPostResponseTests.swift
//  RedditFeedSTests
//
//  Created by Bogdan Laukhin on 8/25/21.
//

import XCTest
@testable import RedditFeedS


class PagedPostResponseTests: XCTestCase {
    
    var pagedPostResponse: PagedPostResponse!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        pagedPostResponse = nil
    }
    
    
    func test_afterLink_is_valid() throws {
        let json = testDataValidJson()
        pagedPostResponse = PagedPostResponse(from: json)
        XCTAssertEqual(pagedPostResponse.afterLink, "f8_jte45")
    }
    
    func test_afterLink_is_invalid() throws {
        let json = testDataInvalidJson()
        pagedPostResponse = PagedPostResponse(from: json)
        XCTAssertNil(pagedPostResponse.afterLink)
    }
    
    func test_hasMore_true() throws {
        let json = testDataValidJson()
        pagedPostResponse = PagedPostResponse(from: json)
        XCTAssertTrue(pagedPostResponse.hasMore)
    }
    
    func test_posts_array_is_empty() throws {
        let json = testDataInvalidJson()
        pagedPostResponse = PagedPostResponse(from: json)
        print(pagedPostResponse.posts.count)
        XCTAssertEqual(pagedPostResponse.posts.count, 0)
    }
    
    
    fileprivate func testDataValidJson () -> [String: Any] {
        let json: [String: Any] = ["data": ["activities": [["action": 1, "state": 1]],
                                            "messages": [["body":"hi"]],
                                            "after": "f8_jte45"]]
        return json
    }
    
    fileprivate func testDataInvalidJson () -> [String: Any] {
        let json: [String: Any] = ["message": ["activities": [["action": 1, "state": 1]],
                                            "messages": [["body":"hi"]],
                                            "after": "f8_jte45"]]
        return json
    }
}
