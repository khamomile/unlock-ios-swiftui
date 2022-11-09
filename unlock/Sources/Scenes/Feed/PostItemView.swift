//
//  PostItemView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI
import Kingfisher

struct PostItemView: View {
    @EnvironmentObject var unlockService: UnlockService
    @StateObject var viewModel: PostDetailViewModel = PostDetailViewModel()
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @Binding var path: NavigationPath
    
    @ObservedObject var post: Post
    
    @State private var showStoreDropDown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                HStack(alignment: .top) {
                    KFImage(URL(string: post.authorProfileImage))
                        .placeholder {
                            Color.gray1
                        }
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .frame(width: 36, height: 36)
                    
                    VStack(alignment: .leading) {
                        Text(post.authorFullname)
                            .font(.boldCaption1)
                            .foregroundColor(.gray8)
                        Text(post.createdAt.format(with: "yyyy/MM/dd"))
                            .font(.regularCaption1)
                            .foregroundColor(.gray4)
                    }
                    Spacer()
                    Button {
                        showStoreDropDown.toggle()
                    } label: {
                        Image("dots-horizontal")
                            .padding(6)
                    }
                }
                .overlay (
                    VStack {
                        if showStoreDropDown {
                            Spacer(minLength: 20)
                            
                            SampleDropDown(buttonInfo: getDropdownButtonInfo())
                                .offset(CGSize(width: -11.0, height: 5.0))
                        }
                    }.animation(.easeInOut, value: showStoreDropDown), alignment: .topTrailing
                )
                .padding(.bottom, 16)
            }
            .zIndex(1)
            
            Text(post.title)
                .font(.mediumBody)
                .foregroundColor(.gray8)
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 5)
            
            Utils.attribute(string: post.swiftContent ?? "", color: .gray)
                .lineLimit(3)
                .lineSpacing(3)
                .font(.regularBody)
                .foregroundColor(.gray4)
                .multilineTextAlignment(.leading)
            
            HStack(alignment: .bottom) {
                HStack(alignment: .lastTextBaseline, spacing: 12) {
                    Button {
                        likeDislikeAction()
                    } label: {
                        Image(post.didLike ?? false ? "heart-big-fill" : "heart-big")
                        Text("\(post.likes)")
                            .font(.regularCaption1)
                            .foregroundColor(.gray7)
                    }
                    
                    Button {
                        
                    } label: {
                        Image("comment-big")
                        Text("\(post.commentsCount)")
                            .font(.regularCaption1)
                            .foregroundColor(.gray7)
                    }
                }
                
                Spacer()
                
                if post.images.count > 0 {
                    KFImage(URL(string: post.images.first?.url ?? ""))
                        .placeholder {
                            Color.gray1
                        }
                        .retry(maxCount: 2, interval: .seconds(2))
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                        .onTapGesture {
                            unlockService.postToShowImage = post
                            unlockService.showImageView = true
                        }
                }
            }
        }
        .padding()
        .background(Color.white)
        .frame(maxHeight: 250)
        .onAppear {
            viewModel.post = post
            viewModel.setViewModel(homeFeedViewModel: homeFeedViewModel, discoverFeedViewModel: discoverFeedViewModel, profileViewModel: profileViewModel)
        }
        .onDisappear {
            showStoreDropDown = false
        }
        .navigationDestination(isPresented: $viewModel.moveToReportView) {
            ReportView(postId: post.id)
                .environmentObject(viewModel)
        }
        .navigationDestination(isPresented: $viewModel.moveToEditView) {
            PostComposeView(path: $path, postToEditId: post.id)
                .environmentObject(homeFeedViewModel)
                .environmentObject(discoverFeedViewModel)
                .environmentObject(profileViewModel)
        }
    }
    
    func likeDislikeAction() {
        if post.didLike! {
            post.likes = post.likes - 1
            post.didLike = false
            viewModel.patchDislike(id: post.id)
        } else {
            post.likes = post.likes + 1
            post.didLike = true
            viewModel.patchLike(id: post.id)
        }
    }
    
    func getDropdownButtonInfo() -> [CustomButtonInfo] {
        if unlockService.me.id == viewModel.post?.author {
            let buttonInfo1 = CustomButtonInfo(title: "수정", btnColor: .gray8, action: { viewModel.moveToEditView = true })
            
            let buttonInfo2 = CustomButtonInfo(title: "삭제", btnColor: .red, action: {
                viewModel.deletePost(id: viewModel.post?.id ?? "0")
            })
            
            return [buttonInfo1, buttonInfo2]
        } else {
            let buttonInfo1 = CustomButtonInfo(title: "숨기기", btnColor: .gray8) {
                viewModel.hidePost(id: viewModel.post?.id ?? "")
            }
            
            let buttonInfo2 = CustomButtonInfo(title: "차단하기", btnColor: .gray8) {
                viewModel.postBlock(userId: viewModel.post?.author ?? "")
            }
            
            let buttonInfo3 = CustomButtonInfo(title: "신고하기", btnColor: .red) { viewModel.moveToReportView = true }
            
            return [buttonInfo1, buttonInfo2, buttonInfo3]
        }
    }
}

struct PostItemView_Previews: PreviewProvider {
    static var previews: some View {
        PostItemView(path: .constant(NavigationPath()), post: Post.preview)
            .environmentObject(UnlockService.shared)
            .environmentObject(HomeFeedViewModel())
            .environmentObject(DiscoverFeedViewModel())
            .environmentObject(ProfileViewModel())
    }
}
