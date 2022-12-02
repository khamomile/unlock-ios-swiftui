//
//  HomeView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: HomeFeedViewModel
    
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SimpleHeaderView(title: "Unlock")

                ZStack(alignment: .bottomTrailing) {
                    Color(.init(gray: 0.9, alpha: 0.5))

                    postListView()

                    NavigationLink(value: NavButton.composePost) {
                        Image("pencil")
                            .padding()
                            .background(Circle().fill(Color.gray9.opacity(0.8)))
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
            }
            .toolbar(.visible, for: .tabBar)
            .animation(.default, value: viewModel.isLoadingPost)
            .navigationDestination(for: NavButton.self, destination: { navButton in
                switch navButton {
                case .composePost:
                    PostComposeView()
                        .environmentObject(viewModel)
                        .environmentObject(discoverFeedViewModel)
                        .environmentObject(profileViewModel)
                case .searchUser:
                    SearchView()
                }
            })
            .navigationDestination(for: String.self, destination: { postId in
                PostDetailView(postID: postId)
            })
            .onAppear {
                viewModel.batchUpdateLikesCount()
                notificationViewModel.getUnreadNoti()
            }
        }
    }
    
    func inifitePaging(idx: Int) {
        if idx == viewModel.lastUnhiddenPostIndex() && viewModel.postPagingCalled[idx] == nil {
            if viewModel.pageNo <= viewModel.totalPageNo + 1 {
                if viewModel.newPageUpdated {
                    viewModel.getNextPages(nextPageNo: viewModel.pageNo)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        viewModel.getNextPages(nextPageNo: viewModel.pageNo)
                    }
                }
                viewModel.postPagingCalled[idx] = true
            }
        }
    }
    
    @ViewBuilder
    func postItemView(post: Post) -> some View {
        if !(post.didHide ?? false) && !(post.didBlock ?? false) {
            NavigationLink(value: post.id) {
                PostItemView(post: post)
            }
        } else if post.showTrace ?? false {
            HiddenPostView(post: post)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func postListView() -> some View {
        if viewModel.isLoadingPost {
            ColoredProgressView(color: .gray)
                .frame(maxHeight: .infinity)
        } else {
            if appState.me?.friendsCount == 0 {
                InviteFriendSearchView()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(Array(viewModel.postList.enumerated()), id: \.element.self) { idx, post in
                                postItemView(post: post)
                                .onAppear {
                                    inifitePaging(idx: idx)
                                }
                        }
                        .id(UUID())
                    }
                    .padding(.bottom, 100)
                    .animation(.easeInOut, value: viewModel.postList)
                }
                .refreshable {
                    viewModel.refreshPages()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppState.shared)
            .environmentObject(HomeFeedViewModel())
            .environmentObject(DiscoverFeedViewModel())
            .environmentObject(NotificationViewModel())
            .environmentObject(ProfileViewModel())
    }
}
