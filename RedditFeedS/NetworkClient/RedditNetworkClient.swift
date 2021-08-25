//
//  RedditNetworkClient.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/20/21.
//

import Foundation


final class RedditNetworkClient {
    
    private lazy var baseURL: URL = {
        return URL(string: "https://www.reddit.com/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
    // MARK: - Fetch posts
    func fetchPosts(with afterLink: String?, completion: @escaping (Result<PagedPostResponse, DataResponseError>) -> Void) {
        var parameters: [String : String]?
        if let afterLink = afterLink { parameters = ["after": "\(afterLink)"] }
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(".json"))
        let encodedURLRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
            else {
                completion(Result.failure(DataResponseError.network))
                return
            }
            
            guard let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            
            let decodedResponse = PagedPostResponse(from: json)
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    
    // MARK: - Cancel previous request
    func cancelRequest() {
        self.session.invalidateAndCancel()
    }
}
