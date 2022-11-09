//
//  SettingView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var unlockService: UnlockService
    @StateObject var viewModel = SettingViewModel()
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    
    @State private var moveToMain: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            BasicHeaderView(text: "설정")
            
            List {
                NavigationLink {
                    ProfileEditView()
                        .environmentObject(viewModel)
                } label: {
                    Image("edit")
                    Text("프로필 수정")
                        .font(.lightBody)
                }
                
                NavigationLink {
                    AccountView()
                        .environmentObject(viewModel)
                } label: {
                    Image("account")
                    Text("계정")
                        .font(.lightBody)
                }

                NavigationLink {
                    HelpView()
                } label: {
                    Image("info")
                    Text("도움말")
                        .font(.lightBody)
                }
                
                Button {
                    viewModel.postLogout()
                } label: {
                    HStack {
                        Image("logout")
                        Text("로그아웃")
                            .font(.lightBody)
                    }
                }
            }
            .listStyle(.inset)
        }
        .alert("로그아웃이 완료되었습니다.", isPresented: $viewModel.logoutSuccess) {
            Button("확인", role: .cancel) {
                moveToMain = true
                print(unlockService.me)
            }
        }
        .fullScreenCover(isPresented: $moveToMain) {
            UserInitialView()
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setViewModel(homeFeedViewModel: homeFeedViewModel, discoverFeedViewModel: discoverFeedViewModel)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(UnlockService.shared)
            .environmentObject(HomeFeedViewModel())
            .environmentObject(DiscoverFeedViewModel())
    }
}
