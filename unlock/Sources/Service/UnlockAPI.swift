//
//  UnlockAPI.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/27.
//

import Foundation
import Moya

let hostURL = "https://api.unlock.im"

enum UnlockAPI {
    case postCheckEmailDuplicate(email: String)
    case postSendResetPWEmailCode(email: String)
    case postSendEmailCode(email: String)
    case postCheckEmailCode(email: String, code: String)
    case postCheckUsernameDuplicate(username: String)
    case postProfileImage(file: Data)
    case postRegister(username: String, password: String, email: String, fullname: String, birthDate: Date, gender: String, profileImage: String, emailAuthCode: String)
    
    case login(email: String, password: String)
    case logout
    case registerFcmToken(token: String)
    case putResetPassword(email: String, code: String, newPassword: String)
    case deleteUser
    
    case getMe
    case userLoggedIn
    
    case getFeed(page: Int)
    case getDiscover(page: Int)
    case getPost(id: String)
    
    case postPost(title: String, content: String, htmlContent: String, showPublic: Bool, images: [PostImage])
    case putPost(id: String, title: String, content: String, htmlContent: String, showPublic: Bool, images: [PostImage])
    case postPostImage(file: Data)
    case deletePost(id: String)
    case hidePost(id: String)
    case unhidePost(id: String)
    case patchLike(id: String, mode: String)
    case patchDislike(id: String, mode: String)
    
    case postComment(postId: String, content: String)
    case getComment(postId: String)
    case getHasEverCommented
    
    case postReport(type: String, postId: String?, commentId: String?, reason: Int, content: String)
    
    case getMyPosts
    case putUser(id: String, username: String, fullname: String, birthDate: Date, profileImage: String, bio: String)
    case getBlockedUsers
    
    case getMyFriendList
    case getFriendList(id: String)
    case getFriendMutualRequestList
    case getFriendRequestList
    case getFriendState(id: String)
    case postAcceptFriend(id: String)
    case postRequestFriend(id: String)
    case patchFriend(id: String)
    case deleteFriend(id: String)
    
    case postBlock(userId: String)
    case deleteBlock(userId: String)
    
    case getUser(id: String)
    case getUserList(keyword: String)
    
    case getNotificationList
    case putReadAllNotifications
    case getHasUnreadNotification
    
    case refreshToken
}

extension UnlockAPI: TargetType {
    var baseURL: URL { URL(string: hostURL)! }
    
    var path: String {
        switch self {
            // LOGIN & LOGOUT
        case .login(email: _, password: _): return "/auth/login" // ✅
        case .logout: return "/auth/logout" // ✅
        case .registerFcmToken(token: _): return "/users/fcm/register"
            
            // CHECK LOGIN STATUS
        case .getMe: return "/users/me" // ✅
        case .userLoggedIn: return "/users/is-logged-in" // ✅
            
            // REGISTER PROCESS
        case .postSendEmailCode(email: _): return "/users/check-send-email-code" // ✅
        case .postCheckEmailCode(email: _, code: _): return "/users/check-email-code" // ✅
        case .postCheckUsernameDuplicate(username: _): return "/users/check-username-duplicate" // ✅
        case .postProfileImage(file: _): return "/images/profile" // ✅
        case .postRegister(username: _, password: _, email: _, fullname: _, birthDate: _, gender: _, profileImage: _, emailAuthCode: _): return "/users" // ✅
            
            // RESET PASSWORD
        case .postCheckEmailDuplicate(email: _): return "/users/check-email-duplicate" // ✅
        case .postSendResetPWEmailCode(email: _): return "/users/send-email-code" // ✅
        case .putResetPassword(email: _, code: _, newPassword: _): return "/users/reset-password" // ✅
            
            // EDIT PROFILE & DEACTIVATE USER
        case .putUser(id: let id, username: _, fullname: _, birthDate: _, profileImage: _, bio: _): return "/users/\(id)" // ✅
        case .deleteUser: return "/users/deactivate" // ✅
            
            // PROFILE
        case .getMyPosts: return "/posts/my" // ✅
        case .getBlockedUsers: return "/users/blocks"
        case .postBlock(userId: _): return "/users/blocks"
        case .deleteBlock(userId: let userId): return "/users/blocks/\(userId)"
            
            // REGARDING POST
        case .getPost(id: let id): return "/posts/\(id)" // ✅
        case .patchLike(id: let id, mode: let mode): return "/posts/\(id)/\(mode)" // ✅
        case .patchDislike(id: let id, mode: let mode): return "/posts/\(id)/\(mode)" // ✅
        case .deletePost(id: let id): return "/posts/\(id)" // ✅
        case .hidePost(id: let id): return "/posts/\(id)/hide" // ✅
        case .unhidePost(id: let id): return "/posts/\(id)/unhide" // ✅
        case .postReport(type: _, postId: _, commentId: _, reason: _, content: _): return "/reports" // ✅
            
            // REGARDING COMMENT
        case .getComment(postId: let postId): return "/comments/post/\(postId)" // ✅
        case .postComment(postId: _, content: _): return "/comments"
        case .getHasEverCommented: return "/comments/has-ever-commented"
            
            // FEED
        case .getFeed(page: _): return "/posts/feed" // ✅
        case .getDiscover(page: _): return "/posts/public" // ✅
            
            // COMPOSE
        case .postPost(title: _, content: _, htmlContent: _, showPublic: _, images: _): return "/posts" // ✅
        case .putPost(id: let id, title: _, content: _, htmlContent: _, showPublic: _, images: _): return "/posts/\(id)" // ✅
        case .postPostImage(file: _): return "/images/post" // ✅
            
            // SEARCH & FRIENDS
        case .getUserList(keyword: _): return "/users" // ✅
        case .getFriendMutualRequestList: return "/users/friend-mutual-requests" // ✅
        case .deleteFriend(id: let id): return "/users/friends/\(id)" // ✅
        case .patchFriend(id: let id): return "/users/friends/\(id)" // ✅
        case .postRequestFriend(id: let id): return "/users/friends/\(id)" // ✅
        case .getMyFriendList: return "/users/friends" // ✅
        case .getFriendRequestList: return "/users/friend-requests" // ✅
            
            // NOTIFICATION
        case .getNotificationList: return "/notifications/my" // ✅
        case .putReadAllNotifications: return "/notifications/read" // ✅
        case .getHasUnreadNotification: return "/notifications/has-unread" // ✅
            
        case .getFriendList(id: let id): return "/users/friends/\(id)"
        case .getFriendState(id: let id): return "/users/friend-with-me/\(id)"
        case .postAcceptFriend(id: let id): return "/users/accept-friend/\(id)"
            
        case .getUser(id: let id): return "/users/\(id)"
            
        default: return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
            // LOGIN & LOGOUT
        case .login(email: _, password: _): return .post
        case .logout: return .post
        case .registerFcmToken(token: _): return .patch
            
            // CHECK LOGIN STATUS
        case .getMe: return .get
        case .userLoggedIn: return .get
            
            // REGISTER PROCESS
        case .postSendEmailCode(email: _): return .post
        case .postCheckEmailCode(email: _, code: _): return .post
        case .postCheckUsernameDuplicate(username: _): return .post
        case .postProfileImage(file: _): return .post
        case .postRegister(username: _, password: _, email: _, fullname: _, birthDate: _, gender: _, profileImage: _, emailAuthCode: _): return .post
            
            // RESET PASSWORD
        case .postCheckEmailDuplicate(email: _): return .post
        case .postSendResetPWEmailCode(email: _): return .post
        case .putResetPassword(email: _, code: _, newPassword: _): return .put
            
            // EDIT PROFILE & DEACTIVATE USER
        case .putUser(id: _, username: _, fullname: _, birthDate: _, profileImage: _, bio: _): return .put
        case .deleteUser: return .delete
            
            // PROFILE
        case .getMyPosts: return .get
        case .getBlockedUsers: return .get
        case .postBlock(userId: _): return .post
        case .deleteBlock(userId: _): return .delete
            
            // REGARDING POST
        case .getPost(id: _): return .get
        case .patchLike(id: _, mode: _): return .patch
        case .patchDislike(id: _, mode: _): return .patch
        case .deletePost(id: _): return .delete
        case .hidePost(id: _): return .patch
        case .unhidePost(id: _): return .patch
        case .postReport(type: _, postId: _, commentId: _, reason: _, content: _): return .post
            
            // REGARDING COMMENT
        case .getComment(postId: _): return .get
        case .postComment(postId: _, content: _): return .post
            
            // FEED
        case .getFeed(page: _): return .get
        case .getDiscover(page: _): return .get
            
            // COMPOSE
        case .postPost(title: _, content: _, htmlContent: _, showPublic: _, images: _): return .post
        case .putPost(id: _, title: _, content: _, htmlContent: _, showPublic: _, images: _): return .put
        case .postPostImage(file: _): return .post
            
            // SEARCH & FRIENDS
        case .getUserList(keyword: _): return .get
        case .getFriendMutualRequestList: return .get
        case .deleteFriend(id: _): return .delete
        case .patchFriend(id: _): return .patch
        case .postRequestFriend(id: _): return .post
        case .getMyFriendList: return .get
        case .getFriendRequestList: return .get
            
            // NOTIFICATION
        case .getNotificationList: return .get
        case .putReadAllNotifications: return .put
        case .getHasUnreadNotification: return .get
            
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            // LOGIN & LOGOUT
        case .login(email: let email, password: let password) :
            let params : [String: String] = [ "email" : email, "password" : password ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default )
        case .logout: return .requestPlain
        case .registerFcmToken(token: let token):
            let params: [String : String] = [ "token" : token ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            // CHECK LOGIN STATUS
        case .getMe: return .requestPlain
        case .userLoggedIn: return .requestPlain
            
            // REGISTER PROCESS
        case .postSendEmailCode(email: let email):
            let params: [String: String] = [ "email" : email ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .postCheckEmailCode(email: let email, code: let code):
            let params: [String: String] = [ "email" : email, "code" : code ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .postCheckUsernameDuplicate(username: let username):
            let params: [String: String] = [ "username" : username ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .postProfileImage(file: let file):
            let formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(file), name: "image", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg")]
            return .uploadMultipart(formData)
        case .postRegister(username: let username, password: let password, email: let email, fullname: let fullname, birthDate: let birthDate, gender: let gender, profileImage: let profileImage, emailAuthCode: let emailAuthCode):
            let params: [String: Any] = [
                "username": username,
                "password": password,
                "email": email,
                "fullname": fullname,
                "birthDate": birthDate,
                "gender": gender,
                "profileImage": profileImage,
                "emailAuthCode": emailAuthCode
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
            // RESET PASSWORD
        case .postCheckEmailDuplicate(email: let email):
            let params: [String: String] = [ "email" : email]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .postSendResetPWEmailCode(email: let email):
            let params: [String: Any] = [
                "email": email,
                "isRegister": false
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .putResetPassword(email: let email, code: let code, newPassword: let newPW):
            let params: [String: String] = [
                "code": code,
                "email": email,
                "newPassword": newPW
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
            // EDIT PROFILE & DEACTIVATE USER
        case .putUser(id: _, username: let username, fullname: let fullname, birthDate: let birthDate, profileImage: let profileImage, bio: let bio):
            let params: [String: Any] = [
                "username": username,
                "fullname": fullname,
                "birthDate": birthDate,
                "profileImage": profileImage,
                "bio": bio
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .deleteUser: return .requestPlain
            
            // PROFILE
        case .getMyPosts: return .requestPlain
        case .getBlockedUsers: return .requestPlain
        case .postBlock(userId: let userId):
            return .requestParameters(parameters: [ "id" : userId ], encoding: URLEncoding.default)
        case .deleteBlock(userId: _): return .requestPlain
            
            // REGARDING POST
        case .getPost(id: _): return .requestPlain
        case .patchLike(id: _, mode: _): return .requestPlain
        case .patchDislike(id: _, mode: _): return .requestPlain
        case .deletePost(id: _): return .requestPlain
        case .postReport(type: let type, postId: let postId, commentId: let commentId, reason: let reason, content: let content):
            var params: [String: Any] = [:]
            
            if let postId = postId {
                params = [
                    "type": type,
                    "post": postId,
                    "reason": reason,
                    "content": content
                ]
            }
            
            if let commentId = commentId {
                params = [
                    "type": type,
                    "comment": commentId,
                    "reason": reason,
                    "content": content
                ]
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
            // REGARDING COMMENT
        case .getComment(postId: _): return .requestPlain
        case .postComment(postId: let postId, content: let content):
            let params: [String: String] = [
                "content": content,
                "post": postId
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
            // FEED
        case .getFeed(page: let page):
            return .requestParameters(parameters: [ "page" : page ], encoding: URLEncoding.queryString)
        case .getDiscover(page: let page):
            return .requestParameters(parameters: [ "page" : page ], encoding: URLEncoding.queryString)
            
            // COMPOSE
        case .postPost(title: let title, content: let content, htmlContent: let htmlContent, showPublic: let showPublic, images: let images):
            var imageList: [String : String] = [:]
            
            if images.count > 0 {
                imageList = images.first.map {
                    ["image": $0.image, "url": $0.url]
                }!
            }
            
            let params: [String: Any] = [
                "title": title,
                "showPublic": showPublic,
                "content": content,
                "htmlContent": htmlContent,
                "images": imageList.count == 0 ? [] : imageList
            ]
            print("Params: \(params)")
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .putPost(id: _, title: let title, content: let content, htmlContent: let htmlContent, showPublic: let showPublic, images: let images):
            var imageList: [String : String] = [:]
            
            if images.count > 0 {
                imageList = images.first.map {
                    ["image": $0.image, "url": $0.url]
                }!
            }
            
            let params: [String: Any] = [
                "title": title,
                "showPublic": showPublic,
                "content": content,
                "htmlContent": htmlContent,
                "images": imageList.count == 0 ? [] : imageList
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .postPostImage(file: let file):
            let formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(file), name: "image", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg")]
            return .uploadMultipart(formData)
            
            // FRIENDS
        case .getUserList(keyword: let keyword):
            return .requestParameters(parameters: [ "keyword" : keyword ], encoding: URLEncoding.queryString)
        case .getFriendMutualRequestList: return .requestPlain
        case .deleteFriend(id: _): return .requestPlain
        case .patchFriend(id: _): return .requestPlain
        case .postRequestFriend(id: _): return .requestPlain
        case .getMyFriendList: return .requestPlain
        case .getFriendRequestList: return .requestPlain
            
            // NOTIFICATION
        case .getNotificationList: return .requestPlain
        case .putReadAllNotifications: return .requestPlain
        case .getHasUnreadNotification: return .requestPlain
            
        default: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(email: _, password: _) : return nil
        case .postSendResetPWEmailCode(email: _): return nil
        case .userLoggedIn: return nil
        default: return nil
        }
    }
}
