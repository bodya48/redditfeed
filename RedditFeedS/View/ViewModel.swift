//
//  ViewModel.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/20/21.
//

import Foundation


protocol ViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}


final class ViewModel {
    private weak var delegate: ViewModelDelegate?
    
    private var posts: [Post] = []
    private var currentPage = 1
    private var total = 0
    private var afterLink: String?
    private var isFetchInProgress = false
    
    let networkClient = RedditNetworkClient()
    
    init(delegate: ViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    
    
    // MARK: - Refresh posts
    func refreshPosts() {
        networkClient.cancelRequest()
        currentPage = 1
        afterLink = nil
        posts.removeAll()
        isFetchInProgress = false
        fetchPosts()
    }
    
    
    // MARK: - Fetch posts
    func fetchPosts() {
        guard !isFetchInProgress else { return }
        isFetchInProgress = true
        
        networkClient.fetchPosts(with: afterLink) { result in
            switch result {
            
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
                
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.posts.append(contentsOf: response.posts)
                    
                    if response.hasMore {
                        self.total = response.numberItemsPerPage * self.currentPage
                        self.afterLink = response.afterLink
                    }
                    else {
                        self.total = self.currentCount
                    }
                    
                    if response.posts.count > 0 {
                        if self.currentCount == response.numberItemsPerPage {
                            self.delegate?.onFetchCompleted(with: nil)
                        }
                        else {
                            let indexPathsToReload = self.calculateIndexPathsToReload(from: response.posts)
                            self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        }
                    }
                    else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
                
            }
        }
    }
    
    
    // MARK: -
    private func calculateIndexPathsToReload(from newPosts: [Post]) -> [IndexPath] {
        let startIndex = posts.count - newPosts.count
        let endIndex = startIndex + newPosts.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
