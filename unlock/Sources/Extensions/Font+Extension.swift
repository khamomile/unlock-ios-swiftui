//
//  Font+Extension.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import Foundation

import SwiftUI

enum SourceHanSerifType: String {
    case bold = "Bold"
    case extraLight = "ExtraLight"
    case heavy = "Heavy"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    
    case thin = "Thin"
    case extraBold = "ExtraBold"

    var name: String {
        "SourceHanSerifKR-" + self.rawValue
    }
}

extension Font {
    static var boldCaption1: Font { sourceHanSerif(type: .bold, size: 14) }
    static var boldBody: Font { sourceHanSerif(type: .bold, size: 16) }
    static var boldHeadline: Font { sourceHanSerif(type: .bold, size: 18) }
    static var boldTitle1: Font { sourceHanSerif(type: .bold, size: 20) }
    static var boldTitle2: Font { sourceHanSerif(type: .bold, size: 24) }
    
    static var semiBoldCaption1: Font { sourceHanSerif(type: .semiBold, size: 12) }
    static var semiBoldBody: Font { sourceHanSerif(type: .semiBold, size: 16) }
    static var semiBoldHeadline: Font { sourceHanSerif(type: .semiBold, size: 17) }
    
    static var regularCaption3: Font { sourceHanSerif(type: .regular, size: 9) }
    static var regularCaption2: Font { sourceHanSerif(type: .regular, size: 11) }
    static var regularCaption1: Font { sourceHanSerif(type: .regular, size: 12) }
    static var regularBody: Font { sourceHanSerif(type: .regular, size: 14) }
    static var regularHeadline: Font { sourceHanSerif(type: .regular, size: 18) }
    
    static var mediumCaption1: Font { sourceHanSerif(type: .medium, size: 12) }
    static var mediumBody: Font { sourceHanSerif(type: .medium, size: 16) }
    static var mediumHeadline: Font { sourceHanSerif(type: .medium, size: 24) }
    
    static var lightCaption3: Font { sourceHanSerif(type: .light, size: 12) }
    static var lightCaption2: Font { sourceHanSerif(type: .light, size: 14) }
    static var lightCaption1: Font { sourceHanSerif(type: .light, size: 15) }
    static var lightBody: Font { sourceHanSerif(type: .light, size: 16) }
    static var lightHeadline: Font { sourceHanSerif(type: .light, size: 18) }
    
    static var extraLightHeadline: Font { sourceHanSerif(type: .extraLight, size: 24) }
    
    static func sourceHanSerif(type: SourceHanSerifType, size: CGFloat) -> Font {
        let font = custom(type.name, size: size)
        return font
    }
}
