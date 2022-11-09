//
//  Post.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import Foundation
import SwiftUI

class Post: Identifiable, ObservableObject, Equatable, Hashable {
    let id: String
    
    let title: String
    let content: String
    let htmlContent: String
    let swiftContent: String?
    
    @Published var author: String
    @Published var authorProfileImage: String
    @Published var authorFullname: String

    let createdAt: Date
    let updatedAt: Date
    
    @Published var likes: Int
    @Published var commentsCount: Int
    
    let showPublic: Bool
    
    let images: [PostImage]
    
    @Published var didLike: Bool?
    @Published var didHide: Bool?
    @Published var didBlock: Bool?
    
    @Published var showTrace: Bool?
    
    public static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(data: PostResponse) {
        id = data._id
        
        title = data.title
        content = data.content
        htmlContent = data.htmlContent
        
        author = data.author ?? ""
        authorProfileImage = data.author__profileImage ?? ""
        authorFullname = data.author__fullname ?? "🔒"
        
        createdAt = Date.parseDateTime(from: data.createdAt)!
        updatedAt = Date.parseDateTime(from: data.updatedAt)!
        
        likes = data.likes
        commentsCount = data.comment__count
        
        showPublic = data.showPublic
        
        images = data.images.compactMap {
            PostImage(data: $0)
        }
        
        didLike = data.didLike
        didHide = data.didHide == nil ? false : data.didHide
        didBlock = data.didBlock == nil ? false : data.didBlock
        showTrace = data.showTrace
        
        swiftContent = data.htmlContent.htmlToString
    }
    
    internal init(id: String, title: String, content: String, htmlContent: String, author: String, authorProfileImage: String, authorFullname: String, createdAt: Date, updatedAt: Date, likes: Int, commentsCount: Int, showPublic: Bool, images: [PostImage], didLike: Bool? = nil, didHide: Bool? = nil, didBlock: Bool? = nil, showTrace: Bool? = nil, swiftContent: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.htmlContent = htmlContent
        self.author = author
        self.authorProfileImage = authorProfileImage
        self.authorFullname = authorFullname
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.likes = likes
        self.commentsCount = commentsCount
        self.showPublic = showPublic
        self.images = images
        self.didLike = didLike
        self.didHide = didHide == nil ? false : didHide
        self.didBlock = didBlock == nil ? false : didBlock
        self.showTrace = showTrace
        self.swiftContent = swiftContent
    }
    
    static var preview: Post {
        return Post(id: "1234", title: "테스트임", content: "{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"광견병이나 그런 이야기는 아닙니다. 제가 굉장히 좋아하는 스탠드업 코미디언 '빌버'의 영상입니다.\"}]},{\"type\":\"paragraph\"},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"https://youtu.be/C3T1MZR65Tk\",\"target\":\"_blank\"}}],\"text\":\"https://youtu.be/C3T1MZR65Tk\"}]},{\"type\":\"paragraph\"},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"영상 마지막 부분, \\\"남자와 여자가 감정을 다루는 방식\\\"을 굉장히 인상 깊게 봤습니다. \"}]},{\"type\":\"paragraph\"},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"평범한 일상을 이렇게 재미있고 재치있게 말하는 것도 정말 능력인 것 같아요😙\"}]}]}", htmlContent: "<p>광견병이나 그런 이야기는 아닙니다. 제가 굉장히 좋아하는 스탠드업 코미디언 '빌버'의 영상입니다.</p><p></p><p><a target=\"_blank\" rel=\"noopener noreferrer nofollow\" href=\"https://youtu.be/C3T1MZR65Tk\">https://youtu.be/C3T1MZR65Tk</a></p><p></p><p>영상 마지막 부분, \"남자와 여자가 감정을 다루는 방식\"을 굉장히 인상 깊게 봤습니다. </p><p></p><p>평범한 일상을 이렇게 재미있고 재치있게 말하는 것도 정말 능력인 것 같아요😙</p>", author: "1234", authorProfileImage: "https://unlock-user-media.s3.ap-northeast-2.amazonaws.com/profile/480x480/1667292242103-B22BE5A2-D0BC-4B72-9C71-16F5553DA102.webp", authorFullname: "종인", createdAt: Date(), updatedAt: Date(), likes: 12, commentsCount: 1, showPublic: true, images: [], didLike: nil, didHide: nil, didBlock: nil, showTrace: nil, swiftContent: """
            광견병이나 그런 이야기는 아닙니다. 제가 굉장히 좋아하는 스탠드업 코미디언 '빌버'의 영상입니다.

            https://youtu.be/C3T1MZR65Tk

            영상 마지막 부분, "남자와 여자가 감정을 다루는 방식"을 굉장히 인상 깊게 봤습니다.

            평범한 일상을 이렇게 재미있고 재치있게 말하는 것도 정말 능력인 것 같아요😙
            """
            )
    }
}

class PostImage: Codable {
    let image: String
    let url: String

    init(data: ImageWithURL) {
        image = data.image ?? ""
        url = data.url ?? ""
    }
    
    internal init(url: String, image: String) {
        self.image = image
        self.url = url
    }
}
