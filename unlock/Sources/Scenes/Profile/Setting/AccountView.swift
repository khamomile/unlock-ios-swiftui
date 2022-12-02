//
//  AccountView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: SettingViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            BasicHeaderView(text: "계정")

            List {
                HStack(spacing: 15) {
                    Text("이메일 주소")
                        .font(.lightBody)

                    Text(verbatim: appState.me?.email ?? "")
                        .font(.lightBody)
                        .foregroundColor(.gray6)
                }
                
                NavigationLink {
                    PWResetEmailView()
                } label: {
                    Text("비밀번호 변경")
                        .font(.lightBody)
                }
                
                NavigationLink {
                    BannedUserView()
                        .environmentObject(viewModel)
                } label: {
                    Text("차단된 계정 관리")
                        .font(.lightBody)
                }
                
                Button {
                    appState.setDoublePopup(.deleteAccount(leftAction: nil, rightAction: { viewModel.deleteUser() }))
                } label: {
                    Text("탈퇴하기")
                        .font(.lightBody)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .listStyle(.inset)
        }
        .navigationBarHidden(true)
        .alert("회원 탈퇴가 완료되었습니다.", isPresented: $viewModel.userDeleted) {
            Button("확인", role: .cancel) { }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(AppState.shared)
            .environmentObject(SettingViewModel())
    }
}
