//
//  Friend.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import Foundation
import SwiftUI

enum FriendStatus: Int {
    case noRelationship = 0 // 요청이 없음.
    case waitingAccept = 1 // 친구 수락 대기 상태 + 친구 요청 보낸 상태
    case isFriend = 2 // 친구임
}

class Friend: ObservableObject, Hashable, Equatable, Identifiable {
    let id: String
    
    let requester: User
    let recipient: User
    
    let status: FriendStatus
    
    let createdAt: Date
    let updatedAt: Date
    
    init(data: FriendResponse) {
        id = data._id
        
        requester = User(data: data.requester)
        recipient = User(data: data.recipient)
        
        status = FriendStatus(rawValue: data.status) ?? .noRelationship
        
        createdAt = Date.parseDateTime(from: data.createdAt) ?? Date()
        updatedAt = Date.parseDateTime(from: data.updatedAt) ?? Date()
    }
    
    public static func ==(lhs: Friend, rhs: Friend) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct UnpopulatedFriend {
    let id: String
    
    let requester: User
    let recipient: User
    
    let status: FriendStatus
    
    let createdAt: Date
    let updatedAt: Date
}
