//
//  BannedUserView.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/01.
//

import SwiftUI

struct BannedUserView: View {
    @EnvironmentObject var viewModel: SettingViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            BasicHeaderView(text: "차단된 계정 관리")

            if viewModel.blockedUsers.isEmpty {
                VStack {
                    Text("차단된 계정이 없어요.")
                        .font(.lightCaption2)
                        .foregroundColor(.gray6)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    ForEach(viewModel.blockedUsers) { blockedUser in
                        BannedUserItemView(blockedUser: blockedUser)
                            .environmentObject(viewModel)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getBlockedUserList()
        }
    }
}

struct BannedUserView_Previews: PreviewProvider {
    static var previews: some View {
        BannedUserView()
            .environmentObject(SettingViewModel())
    }
}
