//
//  PostDetailViewModel+Bridge.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/06.
//

import Foundation

// BRIDGING EXTENSION
extension PostDetailViewModel {
    
    // SETTING UP VIEWMODEL
    func setViewModel(homeFeedViewModel: HomeFeedViewModel, discoverFeedViewModel: DiscoverFeedViewModel, profileViewModel: ProfileViewModel) {
        self.homeFeedViewModel = homeFeedViewModel
        self.discoverFeedViewModel = discoverFeedViewModel
        self.profileViewModel = profileViewModel
    }
    
    // BASIC POST LIST UPDATE
    func updatePostListInfo() {
        print("UPDATE POST INFO")
        
        bridgeLikes()
        bridgeHiddenStatus()
        bridgeCommentsCount()
        bridgeAuthorInfo()
    }
    
    // BRIDGE LIKES COUNT & LIKES STATUS
    func bridgeLikes() {
        guard let post = post else { return }
        
        guard let homeFeedViewModel = homeFeedViewModel, let discoverFeedViewModel = discoverFeedViewModel, let profileViewModel = profileViewModel else { return }
        
        // UPDATING LIKES COUNT
        homeFeedViewModel.updateLikesCount(postId: post.id, count: post.likes, didLike: post.didLike ?? false)
        discoverFeedViewModel.updateLikesCount(postId: post.id, count: post.likes, didLike: post.didLike ?? false)
        profileViewModel.updateLikesCount(postId: post.id, count: post.likes)
    }
    
    // BRIDGE HIDDEN STATUS
    func bridgeHiddenStatus() {
        guard let post = post else { return }
        
        guard let homeFeedViewModel = homeFeedViewModel, let discoverFeedViewModel = discoverFeedViewModel else { return }
        
        homeFeedViewModel.updateHiddenPost(postId: post.id, didHide: post.didHide ?? false, showTrace: post.showTrace ?? false)
        discoverFeedViewModel.updateHiddenPost(postId: post.id, didHide: post.didHide ?? false, showTrace: post.showTrace ?? false)
    }
    
    // BRIDGE DELETED STATUS
    func bridgeDeletedPost() {
        guard let post = post else { return }
        
        guard let homeFeedViewModel = homeFeedViewModel, let discoverFeedViewModel = discoverFeedViewModel, let profileViewModel = profileViewModel else { return }
        
        homeFeedViewModel.updateDeletedPost(postId: post.id)
        profileViewModel.updateDeletedPost(postId: post.id)
        discoverFeedViewModel.updateDeletedPost(postId: post.id)
    }
    
    // BRIDGE COMMENT NO
    func bridgeCommentsCount() {
        guard let post = post else { return }

        guard let homeFeedViewModel = homeFeedViewModel, let discoverFeedViewModel = discoverFeedViewModel, let profileViewModel = profileViewModel else { return }

        homeFeedViewModel.updateCommentNo(postId: post.id, commentsCount: post.commentsCount)
        discoverFeedViewModel.updateCommentNo(postId: post.id, commentsCount: post.commentsCount)
        profileViewModel.updateCommentNo(postId: post.id, commentsCount: post.commentsCount)
    }

    func bridgeAuthorInfo() {
        guard let post = post else { return }

        guard let homeFeedViewModel = homeFeedViewModel, let discoverFeedViewModel = discoverFeedViewModel else { return }

        homeFeedViewModel.updateAuthorInfo(postId: post.id, author: post.author, authorFullname: post.authorFullname, authorProfileImage: post.authorProfileImage)
        discoverFeedViewModel.updateAuthorInfo(postId: post.id, author: post.author, authorFullname: post.authorFullname, authorProfileImage: post.authorProfileImage)
    }
    
    func bridgeBlockedUser(blockedUserId: String) {
        guard let homeFeedViewModel = homeFeedViewModel, let discoverFeedViewModel = discoverFeedViewModel else { return }
        
        homeFeedViewModel.updateBlockedUser(blockedUserId: blockedUserId)
        discoverFeedViewModel.updateBlockedUser(blockedUserId: blockedUserId)
    }
}
