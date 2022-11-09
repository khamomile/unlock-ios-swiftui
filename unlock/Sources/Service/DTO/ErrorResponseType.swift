//
//  ErrorResponseType.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/30.
//

import Foundation

struct ErrorResponse: Codable {
    let response: ErrorType
    let status: Int
    let message: String
    let name: String
}

struct ErrorType: Codable {
    let statusCode: Int
    let message: String
    let error: String
}
