//
//  Comment.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import Foundation
import SwiftUI

class Comment: ObservableObject, Identifiable, Hashable, Equatable {
    let id: String
    
    let author: String
    let authorProfileImage: String
    let authorFullname: String
    
    let post: String
    let content: String

    let createdAt: Date
    let updatedAt: Date
    
    public static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(data: CommentResponse) {
        id = data._id
        
        author = data.author
        authorProfileImage = data.author__profileImage
        authorFullname = data.author__fullname
        
        post = data.post
        content = data.content
        
        createdAt = Date.parseDateTime(from: data.createdAt)!
        updatedAt = Date.parseDateTime(from: data.updatedAt)!
    }
    
    internal init(id: String, author: String, authorProfileImage: String, authorFullname: String, post: String, content: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.author = author
        self.authorProfileImage = authorProfileImage
        self.authorFullname = authorFullname
        self.post = post
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    static var preview: Comment {
        return Comment(id: "123", author: "123", authorProfileImage: "https://unlock-user-media.s3.ap-northeast-2.amazonaws.com/profile/480x480/1667292242103-B22BE5A2-D0BC-4B72-9C71-16F5553DA102.webp", authorFullname: "이종인", post: "123", content: "정말 좋은 글이에요.\n라고 할줄 알았냐?", createdAt: Date(), updatedAt: Date())
    }
}
