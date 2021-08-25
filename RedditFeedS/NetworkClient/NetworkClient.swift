//
//  NetworkClient.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/23/21.
//

import Foundation

public enum DownloadResult<T> {
    case success(T)
    case failure(Error)
}


final class Networking: NSObject {
    
    private static func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    public static func downloadImage(url: URL, completion: @escaping (DownloadResult<Data>) -> Void) {
        
        Networking.getData(url: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            completion(.success(data))
        }
    }
}
