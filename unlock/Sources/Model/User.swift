//
//  User.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import Foundation
import SwiftUI

class User: ObservableObject, Hashable, Equatable, Identifiable {
    let id: String
    
    let email: String
    let username: String
    let fullname: String
    let gender: String
    let profileImage: String
    
    let bio: String
    
    let birthDate: Date
    let createdAt: Date
    let updatedAt: Date
    
    let fcmGroupKey: String
    let friendsCount: Int
    
    let isActive: Bool
    
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(data: UserResponse) {
        id = data._id
        
        email = data.email
        username = data.username
        fullname = data.fullname
        gender = data.gender
        profileImage = data.profileImage.replacingOccurrences(of: " ", with: "%20")
        
        bio = data.bio ?? ""
        
        birthDate = Date.parseDateTime(from: data.birthDate) ?? Date()
        createdAt = Date.parseDateTime(from: data.createdAt) ?? Date()
        updatedAt = Date.parseDateTime(from: data.updatedAt) ?? Date()
        
        fcmGroupKey = data.fcmGroupKey ?? ""
        friendsCount = data.friends__count
        isActive = data.isActive
    }
    
    init() {
        id = ""
        
        email = "paullee20204@gmail.com"
        username = "paullee20204"
        fullname = "이종인"
        gender = "male"
        profileImage = ""
        
        bio = "굿 라이프"
        
        birthDate = Date()
        createdAt = Date()
        updatedAt = Date()
        
        fcmGroupKey = ""
        friendsCount = 12
        isActive = false
    }
}
