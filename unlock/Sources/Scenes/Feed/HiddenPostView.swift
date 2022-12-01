//
//  HiddenPostView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct HiddenPostView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: PostDetailViewModel = PostDetailViewModel()
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @ObservedObject var post: Post
    
    var body: some View {
        HStack {
            Text("숨김 처리한 게시물입니다.")
                .font(.mediumBody)
                .foregroundColor(.gray5)
            
            Spacer()
            
            Button {
                viewModel.unhidePost(id: post.id)
            } label: {
                Text("취소하기")
                    .font(.caption)
                    .foregroundColor(.gray5)
            }
            .padding(8.0)
            .overlay {
                RoundedRectangle(cornerRadius: 5).stroke(Color.gray5)
            }
        }
        .padding()
        .background(.white)
        .onAppear {
            viewModel.post = post
        }
    }
}

struct HiddenPostView_Previews: PreviewProvider {
    static var previews: some View {
        HiddenPostView(post: Post.preview)
    }
}
