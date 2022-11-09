//
//  Notification.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import Foundation

enum NotificationType: String {
    case like = "like"
    case comment = "comment"
    case friendRequested = "friend-requested"
    case friendAccepted = "friend-accepted"
    case postAuthorComment = "post-author-comment"
    case unknown = "unknown"
    
    var notiDescription: String {
        switch self {
        case .like: return "님이 좋아요를 눌렀어요💜"
        case .comment: return "님이 댓글을 달았어요💬"
        case .friendRequested: return "님이 친구 요청을 보냈어요👋🏻"
        case .friendAccepted: return "님이 친구 요청을 수락했어요🙌🏻"
        case .postAuthorComment: return "님이 자신의 글에 댓글을 달았어요📣"
        case .unknown: return "무슨 알림일까요?"
        }
    }
}

class Notification: ObservableObject, Hashable, Equatable, Identifiable {
    let id: String
    
    let type: NotificationType
    let linkTo: String
    
    lazy var destPostId: String = {
        switch self.type {
        case .like, .comment, .postAuthorComment:
            let splits = self.linkTo.components(separatedBy: "/post/")
            return splits[1]
        case .friendAccepted, .friendRequested, .unknown:
            return ""
        }
    }()
    
    let sender: NotiUser
    let receiver: String
    
    let createdAt: Date
    let updatedAt: Date
    
    let hasRead: Bool
    
    init(data: NotificationResponse) {
        self.id = data._id
        self.type = NotificationType(rawValue: data.type) ?? .unknown
        self.linkTo = data.linkTo
        self.sender = NotiUser(data: data.sender)
        self.receiver = data.receiver
        self.hasRead = data.hasRead
        self.createdAt = Date.parseDateTime(from: data.createdAt) ?? Date()
        self.updatedAt = Date.parseDateTime(from: data.updatedAt) ?? Date()
    }
    
    internal init(id: String, type: NotificationType, linkTo: String, sender: NotiUser, receiver: String, createdAt: Date, updatedAt: Date, hasRead: Bool) {
        self.id = id
        self.type = type
        self.linkTo = linkTo
        self.sender = sender
        self.receiver = receiver
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.hasRead = hasRead
    }
    
    public static func ==(lhs: Notification, rhs: Notification) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static var preview: Notification {
        return Notification(id: "", type: .comment, linkTo: "", sender: NotiUser.preview, receiver: "", createdAt: Date(), updatedAt: Date(), hasRead: true)
    }
}

class NotiUser: ObservableObject, Hashable, Equatable, Identifiable {
    let id: String
    let profileImage: String
    let fullname: String
    
    init(data: NotiUserResponse) {
        self.id = data._id
        self.profileImage = data.profileImage
        self.fullname = data.fullname
    }
    
    internal init(id: String, profileImage: String, fullname: String) {
        self.id = id
        self.profileImage = profileImage
        self.fullname = fullname
    }
    
    public static func ==(lhs: NotiUser, rhs: NotiUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static var preview: NotiUser {
        return NotiUser(id: "", profileImage: "https://unlock-user-media.s3.ap-northeast-2.amazonaws.com/profile/480x480/1667292242103-B22BE5A2-D0BC-4B72-9C71-16F5553DA102.webp", fullname: "이종인")
    }
}
