//
//  ViewController.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/18/21.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDataSourcePrefetching, ViewModelDelegate, AlertDisplayer {
    
    let tableView = UITableView()
    private var viewModel: ViewModel!
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupRefreshControl()
        setupNavigationBar()
        
        viewModel = ViewModel(delegate: self)
        triggerPullToRefreshManually()
        viewModel.fetchPosts()
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.refreshPosts()
    }
    
    
    
    // MARK: - UITableViewDataSource, UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        
        if isLoadingCell(for: indexPath) {
            return cell
        }
        
        let post = viewModel.post(at: indexPath.row)
        cell.post = post
        
        if let thumbnail = post.thumbnail {
            cell.postImageView.loadThumbnail(urlSting: thumbnail)
            
            var imageWidth: CGFloat = 100
            var imageHeight: CGFloat = kDefaultImageSideSize
            if let thumbnail_width = post.thumbnail_width  {
                imageWidth = CGFloat(thumbnail_width)
            }
            if let thumbnail_height = post.thumbnail_height  {
                imageHeight = CGFloat(thumbnail_height)
            }
            // use thumbnail size received from json to have dynamic image size and keep aspect ratio
            cell.imageWidthConstraint.constant = imageWidth
            cell.imageHeightConstraint.constant = imageHeight
            cell.imageTrailingConstraint.constant = -kDefaultLeftRightMargin
        }
        else {
            // this updates cell layout to fill the width space fully in case there is no image to display
            cell.imageWidthConstraint.constant = 0
            cell.imageHeightConstraint.constant = 0
            cell.imageTrailingConstraint.constant = 0
        }
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPosts()
        }
    }
    
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    
    
    // MARK: - ViewModelDelegate
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        self.refreshControl.endRefreshing()
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            //indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        
        tableView.insertRows(at: newIndexPathsToReload, with: .automatic)
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    
    func onFetchFailed(with reason: String) {
        self.refreshControl.endRefreshing()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title, message: reason, actions: [action])
    }
    
    
    
    // MARK: - Layout Appearnce
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Reddit feed"
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    
    // MARK: - Refresh Control
    fileprivate func setupRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    fileprivate func triggerPullToRefreshManually() {
        refreshControl.beginRefreshing()
        let topPoint = CGPoint(x: 0, y: -1.0 * refreshControl.frame.size.height)
        tableView.setContentOffset(topPoint, animated: true)
    }
    
}

