//
//  DiscoverFeedViewModel+Bridge.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/06.
//

import Foundation

extension DiscoverFeedViewModel {
    func updateLikesCount(postId: String, count: Int, didLike: Bool) {
        updatedLikesCount[postId] = count
        updatedDidLike[postId] = didLike
    }
    
    func batchUpdateLikesCount() {
        for (postId, newLikesCount) in updatedLikesCount {
            print("Post id: \(postId), New count: \(newLikesCount)")
            if let postIndex = self.postList.firstIndex(where: { $0.id == postId }) {
                self.postList[postIndex].likes = newLikesCount
            }
            
            if let postIndex = self.tempPostList.firstIndex(where: { $0.id == postId }) {
                self.tempPostList[postIndex].likes = newLikesCount
            }
        }
        updatedLikesCount = [:]
        
        for (postId, newDidLike) in updatedDidLike {
            print("Post id: \(postId), New didLike: \(newDidLike)")
            if let postIndex = self.postList.firstIndex(where: { $0.id == postId }) {
                self.postList[postIndex].didLike = newDidLike
            }
            
            if let postIndex = self.tempPostList.firstIndex(where: { $0.id == postId }) {
                self.tempPostList[postIndex].didLike = newDidLike
            }
        }
        updatedDidLike = [:]
    }
    
    func updateDeletedPost(postId: String) {
        if let postIndex = self.postList.firstIndex(where: { $0.id == postId }) {
            self.postList.remove(at: postIndex)
        }
        
        if let postIndex = self.tempPostList.firstIndex(where: { $0.id == postId }) {
            self.tempPostList.remove(at: postIndex)
        }
    }

    func updateHiddenPost(postId: String, didHide: Bool, showTrace: Bool) {
        if let postIndex = self.postList.firstIndex(where: { $0.id == postId }) {
            self.postList[postIndex].didHide = didHide
            self.postList[postIndex].showTrace = showTrace
        }
    }
    
    func updateCommentNo(postId: String, commentsCount: Int) {
        if let postIndex = self.postList.firstIndex(where: { $0.id == postId }) {
            self.postList[postIndex].commentsCount = commentsCount
        }
    }
    
    func updateAuthorInfo(postId: String, author: String, authorFullname: String, authorProfileImage: String) {
        if let postIndex = self.postList.firstIndex(where: { $0.id == postId }) {
            if self.postList[postIndex].author != author {
                self.postList[postIndex].author = author
            }
            
            if self.postList[postIndex].authorFullname != authorFullname {
                self.postList[postIndex].authorFullname = authorFullname
            }
            
            if self.postList[postIndex].authorProfileImage != authorProfileImage {
                self.postList[postIndex].authorProfileImage = authorProfileImage
            }
        }
    }
    
    func updateBlockedUser(blockedUserId: String) {
        for post in postList {
            if post.author == blockedUserId {
                post.didBlock = true
            }
        }
        
        for post in tempPostList {
            if post.author == blockedUserId {
                post.didBlock = true
            }
        }
    }
    
    func updateUnblockedUser(unblockedUserId: String) {
        for post in postList {
            if post.author == unblockedUserId {
                post.didBlock = false
            }
        }
        
        for post in tempPostList {
            if post.author == unblockedUserId {
                post.didBlock = false
            }
        }
    }
}
