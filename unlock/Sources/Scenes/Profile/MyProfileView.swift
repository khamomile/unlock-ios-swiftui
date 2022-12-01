//
//  MyProfileView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct MyProfileView: View {
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProfileHeaderView(title: "Profile")
                
                ScrollView(showsIndicators: false) {
                    ProfileGeneralView()
                        .environmentObject(appState.me)
                    
                    ProfilePostView()
                        .environmentObject(viewModel)
                }
                .refreshable {
                    viewModel.getMyPosts()
                }

                Spacer()
            }
            .onAppear {
                viewModel.batchUpdateLikesCount()
            }
        }
        .onAppear {
            notificationViewModel.getUnreadNoti()
        }
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
            .environmentObject(AppState.shared)
            .environmentObject(ProfileViewModel())
            .environmentObject(NotificationViewModel())
    }
}
