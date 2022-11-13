//
//  UnlockError.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/27.
//

import Foundation

enum UnlockError: String, Error {

    // Client Error
    case unknown = "0000"
    case unauthorized = "0401"
    case forbidden = "0403"
    case network = "0404"
    case serverError = "0500"

    init(code: String) {
        self = (.init(rawValue: code) ?? .unknown)
    }
    
    var message: String {
        switch self {
        case .unknown: return "알 수 없는 문제가 발생하였습니다."
        case .unauthorized: return "인증되지 않은 사용자입니다."
        case .forbidden: return "권한이 없는 사용자입니다."
        case .network: return "서버 에러가 발생하였습니다."
        case .serverError: return "서버 에러가 발생하였습니다."
        }
    }
}
