//
//  AccountView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: SettingViewModel
    
    @State private var moveToMain: Bool = false
    @State private var showPopup: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BasicHeaderView(text: "계정")
                List {
                    HStack(spacing: 15) {
                        Text("이메일 주소")
                            .font(.lightBody)
                        Text(verbatim: unlockService.me.email)
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
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showPopup = true
                        }
                    } label: {
                        Text("탈퇴하기")
                            .font(.lightBody)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .listStyle(.inset)
            }
            
            if unlockService.showPopup {
                DoublePopupView(mainText: "정말 탈퇴하시겠습니까?", leftOptionText: "취소", rightOptionText: "확인", rightAction: { viewModel.deleteUser() })
                    .zIndex(1)
            }
        }
        .navigationBarHidden(true)
        .onChange(of: showPopup, perform: { newShowPopup in
            if newShowPopup == true {
                withAnimation(.easeInOut(duration: 0.2)) {
                    unlockService.showPopup = newShowPopup
                }
                showPopup = false
            }
        })
        .alert("회원 탈퇴가 완료되었습니다.", isPresented: $viewModel.userDeleted) {
            Button("확인", role: .cancel) {
                moveToMain = true
            }
        }
        .fullScreenCover(isPresented: $moveToMain) {
            UserInitialView()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(UnlockService.shared)
            .environmentObject(SettingViewModel())
    }
}
