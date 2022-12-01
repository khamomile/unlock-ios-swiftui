//
//  CommentItemView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI
import Kingfisher

struct CommentItemView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: PostDetailViewModel
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var comment: Comment
    
    @State private var showStoreDropDown: Bool = false
    @State private var myZindex: Double = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 6) {
                KFImage(URL(string: comment.authorProfileImage))
                    .placeholder {
                        Color.gray1
                    }
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    .frame(width: 20, height: 20)
                
                Text(comment.authorFullname)
                    .font(.caption2)
                    .foregroundColor(.gray7)
                
                Spacer()
                
                if comment.author != unlockService.me.id {
                    Button {
                        showStoreDropDown.toggle()
                        myZindex = myZindex == 10 ? 1 : 10
                    } label: {
                        Image("dots-horizontal")
                            .frame(width: 5)
                            .padding(.trailing, 16)
                    }
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
            .zIndex(1)
            
            Text(comment.content)
                .multilineTextAlignment(.leading)
                .font(.regularBody)
                .foregroundColor(.gray7)
            
            Text(comment.createdAt.format(with: "yyyy/MM/dd"))
                .font(.regularCaption2)
                .foregroundColor(.gray4)
        }
        .padding(EdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16))
        .onDisappear {
            showStoreDropDown = false
        }
        .zIndex(myZindex)
        .navigationDestination(isPresented: $viewModel.moveToReportCommentView) {
            ReportView(commentID: comment.id)
                .environmentObject(viewModel)
        }
    }
    
    func getDropdownButtonInfo() -> [CustomButtonInfo] {
        let buttonInfo1 = CustomButtonInfo(title: "차단하기", btnColor: .gray8) {
            unlockService.setDoublePopup(.blockUser(leftAction: nil, rightAction: {
                viewModel.postBlock(userId: comment.author)
                viewModel.getComment(id: viewModel.post?.id ?? "")
            }, userFullname: comment.authorFullname))
        }
        
        let buttonInfo2 = CustomButtonInfo(title: "신고하기", btnColor: .red) {
            viewModel.reportCommentId = comment.id
            viewModel.moveToReportCommentView = true
        }
        
        return [buttonInfo1, buttonInfo2]
    }
}

struct CommentItemView_Previews: PreviewProvider {
    static var previews: some View {
        CommentItemView(comment: Comment.preview)
            .environmentObject(UnlockService.shared)
            .environmentObject(PostDetailViewModel())
    }
}
