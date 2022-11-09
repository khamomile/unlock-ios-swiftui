//
//  ReportItemView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct ReportItemView: View {
    var description: String
    
    var body: some View {
        Button {
            
        } label: {
            Image("checkbox")
            Text(description)
                .font(.mediumBody)
                .foregroundColor(.gray7)
        }
    }
}

struct ReportItemView_Previews: PreviewProvider {
    static var previews: some View {
        ReportItemView(description: "위혐 또는 혐오 발언")
    }
}
