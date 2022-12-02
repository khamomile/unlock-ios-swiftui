//
//  PostInsideView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI
import Kingfisher

struct PostInsideView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: PostDetailViewModel
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                KFImage(URL(string: viewModel.post?.authorProfileImage ?? ""))
                    .placeholder {
                        Color.gray1
                    }
                    .retry(maxCount: 2, interval: .seconds(2))
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading) {
                    Text(viewModel.post?.authorFullname ?? "")
                        .font(.boldCaption1)
                        .foregroundColor(.gray8)

                    Text(viewModel.post?.updatedAt.format(with: "yyyy/MM/dd") ?? "")
                        .font(.regularCaption1)
                        .foregroundColor(.gray4)
                }
                Spacer()
            }
            .padding(.bottom, 16)

            Text(viewModel.post?.title ?? "")
                .font(.boldBody)
                .foregroundColor(.gray8)
                .padding(.bottom, 16)

            Utils.attribute(string: viewModel.post?.swiftContent ?? "", color: .gray)
                .font(.regularBody)
                .foregroundColor(.gray8)
                .lineSpacing(3)
                .padding(.bottom, 16)

            HStack {
                HStack(spacing: 12) {
                    Button {
                        likeDislikeAction()
                    } label: {
                        Image(viewModel.post?.didLike ?? false ? "heart-big-fill" : "heart-big")
                        Text("\(viewModel.post?.likes ?? 0)")
                            .font(.regularCaption1)
                            .foregroundColor(.gray7)
                    }

                    Image("comment-big")

                    Text("\(viewModel.post?.commentsCount ?? 0)")
                        .font(.regularCaption1)
                        .foregroundColor(.gray7)
                }
                Spacer()

                if viewModel.post?.images.count ?? 0 > 0 {
                    KFImage(URL(string: viewModel.post?.images.first?.url ?? ""))
                        .placeholder {
                            Color.gray1
                        }
                        .retry(maxCount: 2, interval: .seconds(2))
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                        .onTapGesture {
                            appState.postToShowImage = viewModel.post
                            appState.showImageView = true
                        }
                }
            }
        }
        .padding()
    }
    
    func likeDislikeAction() {
        if viewModel.post?.didLike ?? false {
            viewModel.post?.likes = (viewModel.post?.likes ?? 0) - 1
            viewModel.post?.didLike = false
            viewModel.patchDislike(id: viewModel.post?.id ?? "")
        } else {
            viewModel.post?.likes = (viewModel.post?.likes ?? 0) + 1
            viewModel.post?.didLike = true
            viewModel.patchLike(id: viewModel.post?.id ?? "")
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostInsideView()
            .environmentObject(PostDetailViewModel())
            .environmentObject(ProfileViewModel())
    }
}
