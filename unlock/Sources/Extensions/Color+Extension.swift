//
//  Color+Extension.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/27.
//

import Foundation
import SwiftUI

extension Color {
    static var gray0 : Color { fetchColor(#function) }
    static var gray1 : Color { fetchColor(#function) }
    static var gray2 : Color { fetchColor(#function) }
    static var gray3 : Color { fetchColor(#function) }
    static var gray4 : Color { fetchColor(#function) }
    static var gray5 : Color { fetchColor(#function) }
    static var gray6 : Color { fetchColor(#function) }
    static var gray7 : Color { fetchColor(#function) }
    static var gray8 : Color { fetchColor(#function) }
    static var gray9 : Color { fetchColor(#function) }
    
    static var blue1: Color { fetchColor(#function) }
    
    static var green1: Color { fetchColor(#function) }
    
    static var red1: Color { fetchColor(#function) }
    
    static var orange1: Color { fetchColor(#function) }
    
    static var pink1: Color { fetchColor(#function) }
    
    private static func fetchColor(_ name: String) -> Color {
        let color = Color(name)
        return color
    }
}
