//
//  ValidResponseType.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/27.
//

import Foundation
import Moya

struct BaseResponseModel<Decode: Decodable>: Decodable {
    let status: Int
    let data: Decode?
    let success: Bool
    let message: String?
}

struct LoginResponse: Codable, Equatable {
    var success: Bool
    var access_token: String
}

struct SuccessResponse: Codable, Equatable {
    var success: Bool
}

struct isDuplicateResponse: Codable, Equatable {
    var isDuplicate: Bool
}

struct CountResponse: Codable, Equatable {
    var count: Int
}

struct CustomImage: Codable, Equatable  {
    let _id: String
    let transforms: [S3ImageTransform]
    let mimetype: String
}

enum S3_IMAGE_TRANSFORM_ID: String, Codable {
    case cropped = "480x480"
    case original = "original"
}

struct S3ImageTransform: Codable, Equatable {
    // let id: S3_IMAGE_TRANSFORM_ID.RawValue
    let key: String
    let location: String
}

struct ImageWithURL: Codable, Equatable {
    let _id: String
    
    let image: String?
    let url: String?
}

struct UserResponse: Codable, Equatable {
    let _id: String
    
    let email: String
    let username: String
    let fullname: String
    let gender: String
    let profileImage: String
    
    let bio: String?
    let password: String?
    
    let birthDate: String
    let createdAt: String
    let updatedAt: String
    
    let fcmGroupKey: String?
    let friends__count: Int
    
    let isActive: Bool
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs._id == rhs._id
    }
}

struct PostResponse: Codable, Equatable {
    let _id: String
    let isActive: Bool
    let showPublic: Bool
    
    let author: String?
    let author__fullname: String?
    let author__profileImage: String?
    
    let likes: Int
    let comment__count: Int
    
    let title: String
    let content: String
    let htmlContent: String
    
    let images: [ImageWithURL]
    
    let createdAt: String
    let updatedAt: String
    
    let didLike: Bool?
    let didHide: Bool?
    let didBlock: Bool?
    
    let showTrace: Bool?
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs._id == rhs._id
    }
}

struct PaginatedResultResponse: Codable, Equatable {
    let page: Int
    let docs: [PostResponse]
    
    let totalDocs: Int
    let totalPages: Int
    let limit: Int
    let pagingCounter: Int
    
    let hasPrevPage: Bool
    let hasNextPage: Bool
    
    let prevPage: Int?
    let nextPage: Int?
}

struct ReportResponse: Codable {
    let _id: String
    
    let createdBy: String
    let createdAt: String
    let updatedAt: String
    
    let post: String?
    let comment: String?
    
    let type: String
    let reason: Int
    let content: String
}

struct CommentResponse: Codable {
    let _id: String
    
    let author: String
    let author__fullname: String
    let author__profileImage: String
    
    let content: String
    let createdAt: String
    let updatedAt: String
    
    let isActive: Bool
    
    let post: String
}

struct FriendResponse: Codable {
    let _id: String
    
    let requester: UserResponse
    let recipient: UserResponse
    
    let status: Int
    
    let createdAt: String
    let updatedAt: String
}

struct FriendRequestResponse: Codable {
    let _id: String
    
    let requester: UserResponse
    let recipient: String
    
    let status: Int
    
    let createdAt: String
    let updatedAt: String
}

struct BlockedUserResponse: Codable {
    let _id: String
    
    let target: UserResponse
}

struct NotificationResponse: Codable {
    let _id: String
    
    let createdAt: String
    let updatedAt: String
    
    let hasRead: Bool
    let linkTo: String
    
    let receiver: String
    let sender: NotiUserResponse
    
    let type: String
}

struct NotiUserResponse: Codable {
    let _id: String
    let fullname: String
    let profileImage: String
}


//struct ResponseData<Model: Codable> {
//    struct CommonResponse: Codable {
//        let result: Model
//    }
//
//    static func processResponse(_ result: Result<Response, MoyaError>) -> Result<Model?, Error> {
//        switch result {
//        case .success(let response):
//            do {
//                // status code가 200...299인 경우만 success로 체크 (아니면 예외발생)
//                _ = try response.filterSuccessfulStatusCodes()
//
//                let commonResponse = try JSONDecoder().decode(CommonResponse.self, from: response.data)
//                return .success(commonResponse.result)
//            } catch {
//                return .failure(error)
//            }
//
//        case .failure(let error):
//            return .failure(error)
//        }
//    }
//
//}


