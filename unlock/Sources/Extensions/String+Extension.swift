//
//  String+Extension.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/28.
//

import Foundation

extension String {
    // REF: https://ios-development.tistory.com/379
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }

        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)

        return String(self[startIndex ..< endIndex])
    }
}
