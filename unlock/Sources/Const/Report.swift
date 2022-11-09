//
//  Report.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/05.
//

import Foundation

enum ReportType: String {
    case post = "post"
    case comment = "comment"
}

enum ReportItem: CaseIterable, Identifiable {
    case hateSpeech
    case violence
    case sexual
    case fraud
    
    var id: Int { return self.option }
    
    var description: String {
        switch self {
        case .hateSpeech: return "위협 또는 혐오 발언"
        case .violence: return "폭력을 조장하는 행위"
        case .sexual: return "성적 내용"
        case .fraud: return "사기 또는 사칭 행위"
        }
    }
    
    var option: Int {
        switch self {
        case .hateSpeech: return 0
        case .violence: return 1
        case .sexual: return 2
        case .fraud: return 3
        }
    }
}
