//
//  CommentView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject var unlockSerice: UnlockService
    @EnvironmentObject var viewModel: PostDetailViewModel
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.comments) { comment in
                CommentItemView(comment: comment)
            }
            .id(UUID())
        }
        .navigationDestination(isPresented: $viewModel.moveToReportCommentView) {
            ReportView(commentId: viewModel.reportCommentId)
                .environmentObject(viewModel)
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
            .environmentObject(PostDetailViewModel())
    }
}
