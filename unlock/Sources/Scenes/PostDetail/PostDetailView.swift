//
//  PostDetailView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI
import Introspect

struct PostDetailView: View {
    // AppState + PostDetailViewModel
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: PostDetailViewModel = PostDetailViewModel()
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @FocusState private var isFocused: Bool

    @State private var showDropDown: Bool = false
    
    var postID: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                PostDetailHeaderView(showStoreDropDown: $showDropDown)
                    .environmentObject(viewModel)
                    .environmentObject(profileViewModel)
                    .zIndex(1)
                
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack {
                            PostInsideView()
                                .environmentObject(viewModel)
                                .environmentObject(profileViewModel)
                        }
                        .animation(.default, value: viewModel.post)
                        
                        Divider()
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        
                        VStack {
                            if viewModel.post?.author == "" {
                                LockedCommentView()
                            } else {
                                CommentView()
                                    .environmentObject(viewModel)
                                    .padding(.leading, 20)
                                    .id(3)
                            }
                        }
                        .padding(.bottom, 50)
                        .animation(.easeIn, value: viewModel.comments)
                        .onChange(of: viewModel.newCommentAdded) { _ in
                            withAnimation {
                                proxy.scrollTo(3, anchor: .bottom)
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.getPost(id: postID)
                    viewModel.getComment(id: postID)
                }
                .onTapGesture {
                    isFocused = false
                }
                
                CommentComposeView(isFocused: _isFocused, id: postID)
                    .environmentObject(viewModel)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            }
            
            if appState.showImageView {
                if let post = appState.postToShowImage {
                    PostImageView(title: post.title, imageURL: post.images.first?.url ?? "", opacity: 0.4)
                        .zIndex(1)
                }
            }
            
            if appState.showPopup {
                if let doublePopupToShow = appState.doublePopupToShow {
                    DoublePopupView(doublePopupInfo: doublePopupToShow)
                        .zIndex(1)
                }
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $viewModel.moveToReportPostView) {
            ReportView(postID: postID)
                .environmentObject(viewModel)
        }
        .navigationDestination(isPresented: $viewModel.moveToEditView) {
            PostComposeView(postToEditId: postID)
                .environmentObject(homeFeedViewModel)
                .environmentObject(discoverFeedViewModel)
                .environmentObject(profileViewModel)
        }
        .onTapGesture {
            showDropDown = false
        }
        .onAppear {
            print("Post ID: \(postID)")
            viewModel.getPost(id: postID)
            viewModel.getComment(id: postID)
            viewModel.setViewModel(homeFeedViewModel: homeFeedViewModel, discoverFeedViewModel: discoverFeedViewModel, profileViewModel: profileViewModel)
        }
        .onDisappear {
            showDropDown = false
        }
        .introspectNavigationController { navController in
            if navController.viewControllers.count == 3 {
                navController.viewControllers = [navController.viewControllers[0], navController.viewControllers[2]]
            }
            
            if navController.viewControllers.count == 4 {
                navController.viewControllers = [navController.viewControllers[0], navController.viewControllers[3]]
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView()
            .environmentObject(AppState.shared)
            .environmentObject(HomeFeedViewModel())
            .environmentObject(DiscoverFeedViewModel())
            .environmentObject(ProfileViewModel())
    }
}
