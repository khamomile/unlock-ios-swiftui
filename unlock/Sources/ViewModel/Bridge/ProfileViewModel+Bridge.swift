//
//  ProfileViewModel+Bridge.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/06.
//

import Foundation

extension ProfileViewModel {
    func updateLikesCount(postId: String, count: Int) {
        updatedLikesCount[postId] = count
    }
    
    func batchUpdateLikesCount() {
        for (postId, newLikesCount) in updatedLikesCount {
            if let postIndex = self.myPosts.firstIndex(where: { $0.id == postId }) {
                self.myPosts[postIndex].likes = newLikesCount
            }
        }
        updatedLikesCount = [:]
    }
    
    func updateDeletedPost(postId: String) {
        if let postIndex = self.myPosts.firstIndex(where: { $0.id == postId }) {
            self.myPosts.remove(at: postIndex)
        }
    }
    
    func updateCommentNo(postId: String, commentsCount: Int) {
        if let postIndex = self.myPosts.firstIndex(where: { $0.id == postId }) {
            self.myPosts[postIndex].commentsCount = commentsCount
        }
    }
}
