//
//  CustomButtonInfo.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/03.
//

import Foundation
import SwiftUI

enum CustomAction {
    case edit(action: () -> Void)
    case delete(action: () -> Void)
    case hide(action: () -> Void)
    case block(action: () -> Void)
    case report(action: () -> Void)
    
    var actionName: String {
        switch self {
        case .edit(_): return "수정"
        case .delete(_): return "삭제"
        case .hide(_): return "숨기기"
        case .block(_): return "차단하기"
        case .report(_): return "신고하기"
        }
    }
    
    var actionColor: Color {
        switch self {
        case .edit(_): return .gray8
        case .delete(_): return .red1
        case .hide(_): return .gray8
        case .block(_): return .gray8
        case .report(_): return .red1
        }
    }
    
    var customButtonInfo: CustomButtonInfo {
        switch self {
        case .edit(let action):
            return CustomButtonInfo(title: self.actionName, btnColor: .gray8, action: action)
        case .delete(let action):
            return CustomButtonInfo(title: self.actionName, btnColor: .red1, action: action)
        case .hide(let action):
            return CustomButtonInfo(title: self.actionName, btnColor: .gray8, action: action)
        case .block(let action):
            return CustomButtonInfo(title: self.actionName, btnColor: .gray8, action: action)
        case .report(let action):
            return CustomButtonInfo(title: self.actionName, btnColor: .red1, action: action)
        }
    }
}


struct CustomButtonInfo: Hashable {
    let id: String = UUID().uuidString
    
    let title: String
    let btnColor: Color
    let action: () -> Void
    let needWillDoAction: Bool = false
    
    static func == (lhs: CustomButtonInfo, rhs: CustomButtonInfo) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
