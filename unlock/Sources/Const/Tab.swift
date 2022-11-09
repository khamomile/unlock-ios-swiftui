//
//  Tab.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import Foundation
import SwiftUI

enum Tab {
    case home
    case discover
    case notification
    case my

    var nonActiveImage: Image {
        switch self {
        case .home: return Image("home")
        case .discover: return Image("discover")
        case .notification: return Image("notification")
        case .my: return Image("my")
        }
    }
    
    var activeImage: Image {
        switch self {
        case .home: return Image("home-active")
        case .discover: return Image("discover-active")
        case .notification: return Image("notification-active")
        case .my: return Image("my-active")
        }
    }
}
