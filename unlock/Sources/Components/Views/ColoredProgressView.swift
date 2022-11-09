//
//  ColoredProgressView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/29.
//

import SwiftUI

struct ColoredProgressView: View {
    var color: Color
    
    var body: some View {
        ProgressView()
            .tint(color)
            .padding(.vertical, 17)
            .frame(maxWidth: .infinity)
    }
}

struct ColoredProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ColoredProgressView(color: .gray)
    }
}
