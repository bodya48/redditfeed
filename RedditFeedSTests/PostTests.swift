//
//  PostTests.swift
//  RedditFeedSTests
//
//  Created by Bogdan Laukhin on 8/25/21.
//

import XCTest
@testable import RedditFeedS


class PostTests: XCTestCase {
    
    var post: Post!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        post = nil
    }
    
    
    func test_post_has_no_data() throws {
        let json = testDataInvalidJson()
        post = Post(from: json)
        XCTAssertNil(post.title)
        XCTAssertNil(post.score)
        XCTAssertNil(post.commentsNumber)
        XCTAssertNil(post.thumbnail)
    }
    
    func test_title_is_valid() throws {
        let json = testDataValidJson()
        post = Post(from: json)
        XCTAssertEqual(post.title, "Have you seen the new Hero 2021 movie?")
    }
    
    
    fileprivate func testDataValidJson () -> [String: Any] {
        let json: [String: Any] = ["data": ["title": "Have you seen the new Hero 2021 movie?",
                                            "score": 15356,
                                            "commentsNumber": 19456]]
        return json
    }
    
    fileprivate func testDataInvalidJson () -> [String: Any] {
        let json: [String: Any] = ["message": ["activities": [["action": 1, "state": 1]],
                                            "messages": [["body":"hi"]],
                                            "after": "f8_jte45"]]
        return json
    }

}
