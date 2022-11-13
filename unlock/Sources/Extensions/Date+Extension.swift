//
//  Date+Extension.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/31.
//

import Foundation

extension Date {
    func format(with format: String = "yyyy/MM/dd") -> String {
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        }()
        
        return formatter.string(from: self)
    }
    
    static func parseDateTime(from date: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxxxx"
        if let date = date {
            return dateFormatter.date(from: date)
        } else {
            return nil
        }
    }
    
    static func parseYMDDate(from date: String) -> Date? {
        var year = Int(date.substring(from: 0, to: 1)) ?? 0
        let month = Int(date.substring(from: 2, to: 3)) ?? 0
        let day = Int(date.substring(from: 4, to: 5)) ?? 0
        
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
        
        return resultDate
    }
}
