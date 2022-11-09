//
//  BasicHeaderView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct BasicHeaderView: View {
    @Environment(\.dismiss) var dismiss
    
    var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Button {
                dismiss()
            } label: {
                Image("angle-left")
            }
            
            Text(text)
                .font(.lightBody)
                .foregroundColor(.gray9)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
    }
}

struct BasicHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BasicHeaderView(text: "친구 목록")
    }
}
