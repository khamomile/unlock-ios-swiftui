//
//  PushNotiType.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/09.
//

import Foundation

enum PushNotiType: Hashable {
    case friend
    case post(id: String)
    case unknown
    
    var postID: String {
        switch self {
        case .friend: return ""
        case .post(let id): return id
        case .unknown: return ""
        }
    }
    
    var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
}
