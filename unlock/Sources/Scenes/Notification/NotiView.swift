//
//  NotiView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct NotiView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: NotificationViewModel
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State var navPath = NavigationPath()
    @State var postIDToShow = ""
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                SimpleHeaderView(title: "Activity")
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        if !appState.isLoading {
                            if viewModel.notiList.count == 0 {
                                EmptyNotiView()
                                    .frame(height: geometry.size.height)
                            } else {
                                ForEach(viewModel.notiList) { noti in
                                    NotiItemView(noti: noti)
                                }
                            }
                        } else {
                            ColoredProgressView(color: .gray)
                                .frame(height: geometry.size.height)
                        }
                    }
                    .refreshable {
                        viewModel.getNotiList()
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationDestination(for: NavButton.self, destination: { navButton in
                switch navButton {
                case .composePost:
                    EmptyView()
                case .searchUser:
                    SearchView()
                }
            })
            .navigationDestination(for: Notification.self, destination: { noti in
                switch noti.type {
                case .like, .comment, .postAuthorComment:
                    PostDetailView(postID: noti.destPostId)
                case .friendAccepted, .friendRequested:
                    FriendListView()
                case .unknown:
                    EmptyView()
                }
            })
            .navigationDestination(isPresented: $viewModel.pushNotiReceived, destination: {
                if let pushNoti = appState.notiDestination {
                    switch pushNoti {
                    case .friend:
                        FriendListView()
                            .onDisappear {
                                if appState.notiDestination != nil {
                                    appState.notiDestination = nil
                                }
                            }
                    case .post:
                        PostDetailView(postID: pushNoti.postID)
                            .onDisappear {
                                if appState.notiDestination != nil {
                                    appState.notiDestination = nil
                                }
                            }
                    case .unknown:
                        EmptyView()
                    }
                }
            })
        }
        .onAppear {
            viewModel.getNotiList()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                viewModel.pushNotiReceived = appState.notiDestination != nil ? true : false
            }
        }
    }
}

struct NotiView_Previews: PreviewProvider {
    static var previews: some View {
        NotiView()
            .environmentObject(AppState.shared)
            .environmentObject(NotificationViewModel())
    }
}
