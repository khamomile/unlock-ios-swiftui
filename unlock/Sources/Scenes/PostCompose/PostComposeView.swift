//
//  PostComposeView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI
import Kingfisher

struct PostComposeView: View {
    @EnvironmentObject var unlockService: UnlockService
    @StateObject var viewModel: PostComposeViewModel = PostComposeViewModel()
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var titleText: String = ""
    @State private var contentText: String = ""
    @State private var postPublicStatus: PostPublicStatus = .isPublic
    
    var postToEditId: String?
    
    var body: some View {
        ZStack {
            VStack {
                PostComposeHeaderView(titleText: $titleText, contentText: $contentText, showPublic: $postPublicStatus)
                    .environmentObject(viewModel)
                
                Divider()
                
                ScrollView {
                    TextField("제목을 입력하세요", text: $titleText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.boldBody)
                        .foregroundColor(.gray9)
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 5, trailing: 16))
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    TextEditorApproachView(text: $contentText, placeholder: "내용을 입력하세요.", editorBackgroundColor: .white)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Divider()
                    .padding(.horizontal, 16)
                
                PostComposeFooterView(postPublicStatus: $postPublicStatus)
                    .environmentObject(viewModel)
            }
            .navigationDestination(isPresented: $viewModel.postSuccess, destination: {
                if viewModel.postId.count > 0 {
                    PostDetailView(postID: viewModel.postId)
                }
            })
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                viewModel.setViewModel(homeFeedViewModel: homeFeedViewModel, discoverFeedViewModel: discoverFeedViewModel, profileViewModel: profileViewModel)
                
                if let postToEditId = postToEditId {
                    viewModel.postToEditId = postToEditId
                    viewModel.getPost()
                }
            }
            .onChange(of: viewModel.postToEdit) { post in
                titleText = post?.title ?? ""
                contentText = post?.swiftContent ?? ""
                postPublicStatus = (post?.showPublic ?? false) ? .isPublic : .isNotPublic
                viewModel.images = post?.images ?? []
            }
            
            if unlockService.showPopup {
                if let doublePopupToShow = unlockService.doublePopupToShow {
                    DoublePopupView(doublePopupInfo: doublePopupToShow)
                        .zIndex(1)
                }
            }
        }
    }
}

struct PostComposeView_Previews: PreviewProvider {
    static var previews: some View {
        PostComposeView()
            .environmentObject(UnlockService.shared)
            .environmentObject(HomeFeedViewModel())
            .environmentObject(DiscoverFeedViewModel())
            .environmentObject(ProfileViewModel())
    }
}
