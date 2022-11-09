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
    
    func dateFromYYMMDD() -> Date {
        var year = Int(self.substring(from: 0, to: 1)) ?? 0
        let month = Int(self.substring(from: 2, to: 3)) ?? 0
        let day = Int(self.substring(from: 4, to: 5)) ?? 0
        
        let now = Date.now
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year], from: now)
        
        if (year > (components.year! - 2000)) {
          year += 1900;
        } else {
          year += 2000;
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let resultDate = Calendar(identifier: .gregorian).date(from: dateComponents)
        
        return resultDate!
    }
}
