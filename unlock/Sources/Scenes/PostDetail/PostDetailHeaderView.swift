//
//  PostDetailHeaderView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct PostDetailHeaderView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: PostDetailViewModel
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @Binding var showStoreDropDown: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                dismiss()
            } label: {
                Image("angle-left")
            }
            
            Spacer()
            
            Text("게시물")
                .font(.lightBody)
                .foregroundColor(.gray9)
                .padding(.leading, 16)
            
            Spacer()
            
            Button {
                showStoreDropDown.toggle()
            } label: {
                Image("dots-horizontal")
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 0))
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
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        // .navigationDestination(isPresented: <#T##Binding<Bool>#>, destination: <#T##() -> View#>)
        .alert("게시물 삭제가 완료되었습니다.", isPresented: $viewModel.deleteSuccess) {
            Button("확인", role: .cancel) {
                dismiss()
            }
        } // 삭제 완료 시 팝업
    }
    
    func getDropdownButtonInfo() -> [CustomButtonInfo] {
        if unlockService.me.id == viewModel.post?.author {
            let buttonInfo1 = CustomButtonInfo(title: "수정", btnColor: .gray8, action: { viewModel.moveToEditView = true })
            
            let buttonInfo2 = CustomButtonInfo(title: "삭제", btnColor: .red, action: {
                unlockService.doublePopupToShow = .deletePost(leftAction: nil, rightAction: { viewModel.deletePost(id: viewModel.post?.id ?? "0") })
                
                withAnimation(.default) {
                    unlockService.showPopup = true
                }
            })
            
            return [buttonInfo1, buttonInfo2]
        } else {
            let buttonInfo1 = CustomButtonInfo(title: "숨기기", btnColor: .gray8) {
                viewModel.hidePost(id: viewModel.post?.id ?? "")
                dismiss()
            }
            
            let buttonInfo2 = CustomButtonInfo(title: "차단하기", btnColor: .gray8) {
                unlockService.doublePopupToShow = .blockUser(leftAction: nil, rightAction: {
                    viewModel.postBlock(userId: viewModel.post?.author ?? "")
                    dismiss()
                }, userFullname: viewModel.post?.authorFullname ?? "")
                
                withAnimation(.default) {
                    unlockService.showPopup = true
                }
            }
            
            let buttonInfo3 = CustomButtonInfo(title: "신고하기", btnColor: .red) { viewModel.moveToReportPostView = true }
            
            return [buttonInfo1, buttonInfo2, buttonInfo3]
        }
    }
}

struct PostDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailHeaderView(showStoreDropDown: .constant(false))
            .environmentObject(UnlockService.shared)
            .environmentObject(PostDetailViewModel())
            .environmentObject(ProfileViewModel())
    }
}
