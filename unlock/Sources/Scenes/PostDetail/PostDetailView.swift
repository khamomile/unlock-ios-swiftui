//
//  PostDetailView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct PostDetailView: View {
    // UnlockService + PostDetailViewModel
    @EnvironmentObject var unlockService: UnlockService
    @StateObject var viewModel: PostDetailViewModel = PostDetailViewModel()
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @FocusState private var isFocused: Bool

    @State private var showDropDown: Bool = false
    @Binding var path: NavigationPath
    
    var postID: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                PostDetailHeaderView(showStoreDropDown: $showDropDown, path: $path)
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
            
            if unlockService.showImageView {
                if let post = unlockService.postToShowImage {
                    PostImageView(title: post.title, imageURL: post.images.first?.url ?? "", opacity: 0.4)
                        .zIndex(1)
                }
            }
            
            if unlockService.showPopup {
                DoublePopupView(mainText: "정말 탈퇴하시겠습니까?", leftOptionText: "취소", rightOptionText: "확인")
                    .zIndex(1)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $viewModel.moveToReportView) {
            ReportView(postId: postID)
                .environmentObject(viewModel)
        }
        .navigationDestination(isPresented: $viewModel.moveToEditView) {
            PostComposeView(path: $path, postToEditId: postID)
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
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(path: .constant(NavigationPath()))
            .environmentObject(UnlockService.shared)
            .environmentObject(HomeFeedViewModel())
            .environmentObject(DiscoverFeedViewModel())
            .environmentObject(ProfileViewModel())
    }
}
