//
//  BannedUserItemView.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/08.
//

import SwiftUI
import Kingfisher

struct BannedUserItemView: View {
    @EnvironmentObject var viewModel: SettingViewModel
    
    var blockedUser: User
    
    var body: some View {
        HStack(spacing: 14) {
            KFImage(URL(string: blockedUser.profileImage))
                .placeholder {
                    Color.gray1
                }
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 42, height: 42)
            
            VStack(alignment: .leading) {
                Text(blockedUser.username)
                    .font(.semiBoldBody)
                    .foregroundColor(.gray8)
                Text(blockedUser.fullname)
                    .font(.regularCaption1)
                    .foregroundColor(.gray5)
            }
            
            Spacer()
            
            Button {
                viewModel.unblockUser(userId: blockedUser.id)
            } label: {
                Text("취소하기")
                    .font(.caption)
                    .foregroundColor(.gray5)
            }
            .padding(8.0)
            .overlay {
                RoundedRectangle(cornerRadius: 5).stroke(Color.gray5)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}

struct BannedUserItemView_Previews: PreviewProvider {
    static var previews: some View {
        BannedUserItemView(blockedUser: User())
            .environmentObject(SettingViewModel())
    }
}
