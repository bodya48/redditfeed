//
//  PostTableViewCell.swift
//  RedditFeedS
//
//  Created by Bogdan Laukhin on 8/23/21.
//

import Foundation
import UIKit


let kDefaultTopMargin: CGFloat = 24
let kDefaultLeftRightMargin: CGFloat = 24
let kDefaultBottomRightMargin: CGFloat = -16
let kDefaultImageSideSize: CGFloat = 75
let kDefaultIconSideSize: CGFloat = 16


class PostTableViewCell: UITableViewCell {
    
    let postImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false;
        return stack
    }()
    
    
    let scoreView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let scoreUpImage: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "arrow.up.square.fill"))
        img.tintColor = .gray
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.clipsToBounds = true
        return img
    }()
    
    let scoreDownImage: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "arrow.down.square.fill"))
        img.tintColor = .gray
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.clipsToBounds = true
        return img
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor =  .gray
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let commentsImage: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "text.bubble.fill"))
        img.tintColor = .gray
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.clipsToBounds = true
        return img
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor =  .gray
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let shareView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let shareImage: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "tray.and.arrow.up.fill"))
        img.tintColor = .gray
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.clipsToBounds = true
        return img
    }()
    
    let shareLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor =  .gray
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Share"
        return label
    }()
    
    
    var post:Post? {
        didSet {
            guard let post = post else { return }
            
            if let title = post.title {
                titleLabel.text = title
            }
            if let score = post.score {
                scoreLabel.text = "\(score)"
            }
            if let commentsNumber = post.commentsNumber {
                commentsLabel.text = "\(commentsNumber)"
            }
        }
    }
    
    var imageWidthConstraint: NSLayoutConstraint!
    var imageHeightConstraint: NSLayoutConstraint!
    var imageTrailingConstraint: NSLayoutConstraint!
    var stackBottomConstraint: NSLayoutConstraint!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUiElementsToContentView()
        setupAutoLayout()
        setupButtonsStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Layout Appearance
    fileprivate func addUiElementsToContentView() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(postImageView)
        self.contentView.addSubview(stackView)
    }
    
    
    fileprivate func setupAutoLayout() {
        postImageView.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: kDefaultTopMargin).isActive = true
        postImageView.bottomAnchor.constraint(lessThanOrEqualTo:stackView.topAnchor, constant: kDefaultBottomRightMargin).isActive = true
        imageTrailingConstraint = NSLayoutConstraint(item: postImageView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -kDefaultLeftRightMargin)
        imageTrailingConstraint.isActive = true
        imageWidthConstraint = NSLayoutConstraint(item: postImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: kDefaultImageSideSize)
        imageHeightConstraint = NSLayoutConstraint(item: postImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: kDefaultImageSideSize)
        imageWidthConstraint.priority = UILayoutPriority(rawValue: 999) // the priority required to solve ambiguously defined constraints for cell width
        imageHeightConstraint.priority = UILayoutPriority(rawValue: 999) // the priority required to solve ambiguously defined constraints for cell height
        imageWidthConstraint.isActive = true
        imageHeightConstraint.isActive = true
        
        titleLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: kDefaultTopMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: kDefaultLeftRightMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:postImageView.leadingAnchor, constant: -kDefaultLeftRightMargin).isActive = true
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo:stackView.topAnchor, constant: kDefaultBottomRightMargin).isActive = true
        
        stackView.heightAnchor.constraint(equalToConstant:20).isActive = true
        stackView.centerXAnchor.constraint(equalTo:self.contentView.centerXAnchor, constant: 0).isActive = true
        stackBottomConstraint = NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -20)
        stackBottomConstraint.priority = UILayoutPriority(rawValue: 999) // the priority required to solve ambiguously defined constraints for cell height
        stackBottomConstraint.isActive = true
    }
    
    
    
    // MARK: - Setup stackView for buttons
    fileprivate func setupButtonsStackView() {
        scoreView.widthAnchor.constraint(equalToConstant: 100).isActive = true;
        scoreView.heightAnchor.constraint(equalToConstant: 20).isActive = true;
        commentsView.widthAnchor.constraint(equalToConstant: 100).isActive = true;
        commentsView.heightAnchor.constraint(equalToConstant: 20).isActive = true;
        shareView.widthAnchor.constraint(equalToConstant: 100).isActive = true;
        shareView.heightAnchor.constraint(equalToConstant: 20).isActive = true;
        
        stackView.addArrangedSubview(scoreView)
        stackView.addArrangedSubview(commentsView)
        stackView.addArrangedSubview(shareView)
        
        setupScoreView()
        setupComentsView()
        setupShareView()
    }
    
    
    fileprivate func setupScoreView() {
        let stack = actionStackView()
        stack.addArrangedSubview(scoreUpImage)
        stack.addArrangedSubview(scoreLabel)
        stack.addArrangedSubview(scoreDownImage)
        scoreView.addSubview(stack)
        
        scoreUpImage.widthAnchor.constraint(equalToConstant: kDefaultIconSideSize).isActive = true;
        scoreUpImage.heightAnchor.constraint(equalToConstant: kDefaultIconSideSize).isActive = true;
        scoreDownImage.widthAnchor.constraint(equalToConstant: kDefaultIconSideSize).isActive = true;
        scoreDownImage.heightAnchor.constraint(equalToConstant: kDefaultIconSideSize).isActive = true;
        stack.centerXAnchor.constraint(equalTo:scoreView.centerXAnchor, constant: 0).isActive = true
        stack.centerYAnchor.constraint(equalTo:scoreView.centerYAnchor, constant: 0).isActive = true
    }
    
    
    fileprivate func setupComentsView() {
        let stack = actionStackView()
        stack.addArrangedSubview(commentsImage)
        stack.addArrangedSubview(commentsLabel)
        commentsView.addSubview(stack)
        
        commentsImage.widthAnchor.constraint(equalToConstant: kDefaultIconSideSize).isActive = true;
        commentsImage.heightAnchor.constraint(equalToConstant: kDefaultIconSideSize).isActive = true;
        stack.centerXAnchor.constraint(equalTo:commentsView.centerXAnchor, constant: 0).isActive = true
        stack.centerYAnchor.constraint(equalTo:commentsView.centerYAnchor, constant: 0).isActive = true
    }
    
    
    fileprivate func setupShareView() {
        let stack = actionStackView()
        stack.addArrangedSubview(shareImage)
        stack.addArrangedSubview(shareLabel)
        shareView.addSubview(stack)
        
        shareImage.widthAnchor.constraint(equalToConstant: kDefaultIconSideSize).isActive = true;
        shareImage.heightAnchor.constraint(equalToConstant: kDefaultIconSideSize).isActive = true;
        stack.centerXAnchor.constraint(equalTo:shareView.centerXAnchor, constant: 0).isActive = true
        stack.centerYAnchor.constraint(equalTo:shareView.centerYAnchor, constant: 0).isActive = true
    }
    
    
    fileprivate func actionStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false;
        return stack
    }
    
}
