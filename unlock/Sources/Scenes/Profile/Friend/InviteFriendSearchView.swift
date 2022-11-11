//
//  InviteFriendSearchView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct InviteFriendSearchView: View {
    @State private var isActivityViewPresented = false
    
    var body: some View {
        VStack(spacing: 5) {
            Text("서로의 마음을 열어봐요.")
                .font(.lightCaption2)
                .foregroundColor(.gray6)
            
            Button {
                isActivityViewPresented = true
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
            .background(
              ActivityView(
                isPresented: $isActivityViewPresented,
                activityItmes: ["Unlock을 함께 사용해보시겠어요?\n\nUnlock은 지인 간 함께 사용할 수 있는 익명 게시글 공유 및 소셜 네트워크 서비스에요 :)", URL(string: "https://linktr.ee/unlock_kr")!]
              )
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct InviteFriendSearchView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendSearchView()
    }
}
