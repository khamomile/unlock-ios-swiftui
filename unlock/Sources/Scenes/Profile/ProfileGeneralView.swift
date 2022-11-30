//
//  ProfileGeneralView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI
import Kingfisher

struct ProfileGeneralView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var me: User
    
    var body: some View {
        VStack {
            KFImage(URL(string: me.profileImage))
                .placeholder {
                    Image(systemName: "person.fill.questionmark")
                }
                .retry(maxCount: 2, interval: .seconds(2))
                .onFailure({ e in
                    unlockService.forceErrorMessage("프로필 이미지 로딩에 실패했습니다.")
                })
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray2)
                })

            Text(me.fullname)
                .font(.semiBoldHeadline)
                .foregroundColor(.gray9)

            Text("@\(me.username)")
                .font(.lightCaption2)
                .foregroundColor(.gray6)
                .padding(.bottom, 10)

            NavigationLink {
                FriendListView()
            } label: {
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Text("친구")
                        .font(.mediumBody)
                        .foregroundColor(.gray9)
                        .padding(.trailing, 5)

                    Text("\(me.friendsCount)")
                        .font(.mediumHeadline)
                        .foregroundColor(.orange1)
                        .padding(.trailing, 2)

                    Text("명")
                        .font(.mediumBody)
                        .foregroundColor(.gray9)
                }
            }

            Text(me.bio)
                .font(.regularBody)
                .padding(10)
                .background(Color.gray0)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray0)
                }
        }
        .padding(.top, 30)
    }
}

struct ProfileGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileGeneralView()
            .environmentObject(UnlockService.shared)
            .environmentObject(User())
    }
}
