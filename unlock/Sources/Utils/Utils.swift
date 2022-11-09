//
//  Utils.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/28.
//

import Foundation
import SwiftUI

class Utils {
    static let shared = Utils()
    
    private init() { }
    
    static func inUrlFormat(_ text: String) -> Bool {
        // REF: https://stackoverflow.com/questions/30997169/regular-expression-to-get-url-in-string-swift-with-capitalized-symbols
        let urlRegex = "((http|https)://)?([(w|W)]{3}+\\.)?+(.)+\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlPred = NSPredicate(format:"SELF MATCHES %@", urlRegex)
        
        return urlPred.evaluate(with: text)
    }
    
    static func inEmailFormat(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: text)
    }
    
    static func inVerificationFormat(_ text: String) -> Bool {
        let cs = CharacterSet.decimalDigits.inverted
        
        guard text.count == 5 && text.rangeOfCharacter(from: cs) == nil else { return false }
        
        return true
    }
    
    static func inIDFormat(_ text: String) -> Bool {
        let charSet: CharacterSet = {
            var cs = CharacterSet.lowercaseLetters
            cs.insert(charactersIn: "0123456789")
            return cs.inverted
        }()
        
        guard text.count >= 5 && text.count <= 20 else {
            return false
        }
        
        guard text.rangeOfCharacter(from: charSet) == nil else {
            return false
        }
        
        return true
    }
    
    static func secondsToMinuteSecond(_ seconds: Int) -> String {
        let min = (seconds % 3600) / 60
        let sec = (seconds % 3600) % 60
        
        return min > 0 ? "\(min)분 \(sec)초" : "\(sec)초"
    }
    
    // REF: https://stackoverflow.com/questions/71541408/swiftui-text-how-can-i-create-a-hyperlink-and-underline-a-weblink-in-a-string
    // REF: https://gist.github.com/SumeetMourya/3700a05ab8cabe4187aff8dbe1cc1035
    static func getMarkupText(url: String) -> String {
        let placeholderText = "[\(url)]"
        var hyperlink: String
        if inEmailFormat(url) {
            hyperlink = "(mailto:\(url))"
        } else {
            if url.hasPrefix("https://www.") {
                hyperlink = "(\(url.replacingOccurrences(of: "https://www.", with: "https://")))"
            } else if url.hasPrefix("https:") {
                hyperlink = "(\(url))"
            } else if url.hasPrefix("http://www.") {
                hyperlink = "(\(url.replacingOccurrences(of: "http://www.", with: "http://")))"
            } else if url.hasPrefix("http:") {
                hyperlink = "(\(url))"
            } else if url.hasPrefix("www.") {
                hyperlink = "(\(url.replacingOccurrences(of: "www.", with: "https://")))"
            } else {
                hyperlink = "(http://\(url))"
            }
        }
        return placeholderText + hyperlink
    }
    
    static func attribute(string: String, color: Color) -> Text {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        else {
            return Text(string)
        }
        
        let stringRange = NSRange(location: 0, length: string.count)
        
        let matches = detector.matches(
            in: string,
            options: [],
            range: stringRange
        )
        
        let attributedString = NSMutableAttributedString(string: string)
        for match in matches {
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single, range: match.range)
        }
        
        var text = Text("")
        attributedString.enumerateAttributes(in: stringRange, options: []) { attrs, range, _ in
            let valueOfString: String = attributedString.attributedSubstring(from: range).string
            text = text + Text(.init((attrs[.underlineStyle] != nil ? getMarkupText(url: valueOfString):  valueOfString)))
        }
        
        return text
    }
}
