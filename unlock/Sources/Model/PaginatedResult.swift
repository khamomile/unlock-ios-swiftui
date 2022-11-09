//
//  PaginatedResult.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import Foundation

struct PaginatedResult {
    // let docs: T[];
    let totalDocs: Int
    let limit: Int
    let totalPages: Int
    let page: Int
    let pagingCounter: Int
    let hasPrevPage: Bool
    let hasNextPage: Bool
    let prevPage: String?
    let nextPage: String?
}
