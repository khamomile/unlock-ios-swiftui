//
//  HTML+Extension.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/02.
//

import Foundation

// REF: https://stackoverflow.com/questions/28124119/convert-html-to-plain-text-in-swift
extension Data {
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        return Data(utf8).htmlToAttributedString
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string.replacingOccurrences(of: "\n$", with: "", options: .regularExpression) ?? ""
    }
    
    func toHTMLContent() -> String {
        let arr = self.components(separatedBy: "\n")
        var resultHTML = ""
        
        for elem in arr {
            if Utils.inUrlFormat(elem) {
                resultHTML += "<p><a target=\"_blank\" rel=\"noopener noreferrer nofollow\" href=\"\(elem)\">\(elem)</a></p>"
            } else {
                resultHTML += "<p>" + elem + "</p>"
            }
        }
        
        return resultHTML
    }
}
