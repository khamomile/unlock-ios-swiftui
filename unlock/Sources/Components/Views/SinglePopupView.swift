//
//  SinglePopupView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct SinglePopupView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("신고가 완료되었습니다.")
                .font(.lightCaption1)
                .foregroundColor(.gray9)
                .padding(.top, 16)
            
            Spacer()
            
            Divider()
                .padding(16)
            
            Button {
                
            } label: {
                Text("확인")
                    .font(.boldBody)
                    .foregroundColor(.gray9)
            }
            .padding(.bottom, 16)
        }
        .frame(width: 320, height: 220)
    }
}

struct SinglePopupView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePopupView()
    }
}
