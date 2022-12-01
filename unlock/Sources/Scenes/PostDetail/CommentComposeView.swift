//
//  CommentComposeView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct CommentComposeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: PostDetailViewModel
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @FocusState var isFocused: Bool
    
    @State private var content: String = ""
    
    var id: String
    
    var body: some View {
        HStack {
            TextField("댓글을 입력하세요.", text: $content, axis: .vertical)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isFocused)
                .font(.regularBody)
    
            Button {
                viewModel.postComment(postId: id, content: content)
                content = ""
                isFocused = false
            } label: {
                content.isEmpty ? Image("submit-comment") : Image("submit-comment-active")
            }
            .disabled(content.isEmpty)

        }
        .padding()
        .background(Color.gray0)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CommentComposeView_Previews: PreviewProvider {
    static var previews: some View {
        CommentComposeView(id: "1234")
    }
}
