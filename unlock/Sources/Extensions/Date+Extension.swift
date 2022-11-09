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
//        let iso8601DateFormatter = ISO8601DateFormatter()
//        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//        let date2 = Date()
//        print(iso8601DateFormatter.string(from: date2))
//        print("???")
//
//        if let date = date {
//            return iso8601DateFormatter.date(from: date)
//        } else {
//            return nil
//        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxxxx"
        if let date = date {
            return dateFormatter.date(from: date)
        } else {
            return nil
        }
    }
}
