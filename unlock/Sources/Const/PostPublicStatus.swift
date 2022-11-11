//
//  PostPublicStatus.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/07.
//

import Foundation

enum PostPublicStatus {
    case isPublic
    case isNotPublic
    
    var boolValue: Bool {
        switch self {
        case .isPublic: return true
        case .isNotPublic: return false
        }
    }
}
