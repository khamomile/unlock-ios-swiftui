//
//  InviteFriendSearchView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct InviteFriendSearchView: View {
    var body: some View {
        VStack(spacing: 5) {
            Text("서로의 마음을 열어봐요.")
                .font(.lightCaption2)
                .foregroundColor(.gray6)
            Button {
                
            } label: {
                VStack(spacing: 5) {
                    Text("친구 초대하기")
                        .font(.boldHeadline)
                        .foregroundColor(.gray8)
                    Rectangle()
                    .foregroundColor(.gray2)
                    .frame(height: (1.0))
                }
                .fixedSize()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct InviteFriendSearchView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendSearchView()
    }
}
