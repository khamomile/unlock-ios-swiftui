//
//  DoublePopupInfo.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/11.
//

import Foundation
import SwiftUI

enum DoublePopupInfo {
    case deleteAccount(leftAction: (() -> Void)?, rightAction: (() -> Void)?)
    case deletePost(leftAction: (() -> Void)?, rightAction: (() -> Void)?)
    case blockUser(leftAction: (() -> Void)?, rightAction: (() -> Void)?, userFullname: String)
    case reportPost(leftAction: (() -> Void)?, rightAction: (() -> Void)?)
    case reportComment(leftAction: (() -> Void)?, rightAction: (() -> Void)?)
    case deleteFriend(leftAction: (() -> Void)?, rightAction: (() -> Void)?, userFullname: String)
    case deleteImageFromPost(leftAction: (() -> Void)?, rightAction: (() -> Void)?)
    
    var mainText: String {
        switch self {
        case .deleteAccount(_, _): return "정말 탈퇴하시겠습니까?"
        case .deletePost(_, _): return "게시물을 삭제하시겠습니까?"
        case .blockUser(_, _, let userFullname): return "\(userFullname)님을 차단할까요?\n앞으로 서로의 활동이 보이지 않아요."
        case .reportPost(_, _): return "게시물을 신고할까요?"
        case .reportComment(_, _): return "댓글을 신고할까요?"
        case .deleteFriend(_, _, let userFullname): return "\(userFullname)님을 친구에서 삭제할까요?"
        case .deleteImageFromPost(_, _): return "사진을 삭제할까요?"
        }
    }
    
    var leftText: String {
        switch self {
        case .deleteAccount(_, _): return "취소"
        case .deletePost(_, _): return "취소"
        case .blockUser(_, _, _): return "취소"
        case .reportPost(_, _): return "취소"
        case .reportComment(_, _): return "취소"
        case .deleteFriend(_, _, _): return "아니요"
        case .deleteImageFromPost(_, _): return "취소"
        }
    }
    
    var rightText: String {
        switch self {
        case .deleteAccount(_, _): return "확인"
        case .deletePost(_, _): return "확인"
        case .blockUser(_, _, _): return "차단"
        case .reportPost(_, _): return "신고하기"
        case .reportComment(_, _): return "신고하기"
        case .deleteFriend(_, _, _): return "네"
        case .deleteImageFromPost(_, _): return "확인"
        }
    }
    
    var leftAction: (() -> Void)? {
        switch self {
        case .deleteAccount(let leftAction, _): return leftAction
        case .deletePost(let leftAction, _): return leftAction
        case .blockUser(let leftAction, _, _): return leftAction
        case .reportPost(let leftAction, _): return leftAction
        case .reportComment(let leftAction, _): return leftAction
        case .deleteFriend(let leftAction, _, _): return leftAction
        case .deleteImageFromPost(let leftAction, _): return leftAction
            
        }
    }
    
    var rightAction: (() -> Void)? {
        switch self {
        case .deleteAccount(_, let rightAction): return rightAction
        case .deletePost(_, let rightAction): return rightAction
        case .blockUser(_, let rightAction, _): return rightAction
        case .reportPost(_, let rightAction): return rightAction
        case .reportComment(_, let rightAction): return rightAction
        case .deleteFriend(_, let rightAction, _): return rightAction
        case .deleteImageFromPost(_, let rightAction): return rightAction
        }
    }
}
