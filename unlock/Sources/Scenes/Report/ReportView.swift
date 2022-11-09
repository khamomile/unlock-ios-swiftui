//
//  ReportView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var viewModel: PostDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    var postId: String?
    var commentId: String?
    
    @State private var content: String = ""
    @State private var selectedReportItem: ReportItem?
    
    var body: some View {
        VStack(alignment: .center) {
            BasicHeaderView(text: "신고하기")
            
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("신고사유를 선택해주세요.")
                            .font(.boldBody)
                            .foregroundColor(.gray8)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        
                        ForEach(ReportItem.allCases) { reportItem in
                            Button {
                                selectedReportItem = reportItem
                            } label: {
                                Image(selectedReportItem == reportItem ? "checkbox-checked" : "checkbox")
                                Text(reportItem.description)
                                    .font(.mediumBody)
                                    .foregroundColor(.gray7)
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        Text("신고내용을 작성해주세요.")
                            .font(.boldBody)
                            .foregroundColor(.gray8)
                            .padding(.horizontal, 16)
                            .padding(.top, 40)
                        
                        TextEditorApproachView(text: $content, placeholder: "예) 위협적인 발언으로 보여 신고합니다.", editorBackgroundColor: .gray1)
                            .padding(.horizontal, 16)
                    }
                }
                
                Button {
                    if let postId = postId {
                        viewModel.reportPost(type: ReportType.post.rawValue, postId: postId, reason: selectedReportItem?.option ?? 0, content: content)
                    }
                    
                    if let commentId = commentId {
                        viewModel.reportComment(type: ReportType.comment.rawValue, commentId: commentId, reason: selectedReportItem?.option ?? 0, content: content)
                    }
                } label: {
                    Text("신고하기")
                        .font(.regularHeadline)
                        .foregroundColor(checkInput() ? .gray8 : .gray2)
                        .padding(EdgeInsets(top: 10, leading: 100, bottom: 10, trailing: 100))
                        .overlay {
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray2)
                        }
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        //.background(Color.white, ignoresSafeAreaEdges: [])
                }
                .disabled(!checkInput())
                .padding(.bottom, 40)
            }
        }
        .alert("게시물 신고가 완료되었습니다.", isPresented: $viewModel.reportSuccess) {
            Button("확인", role: .cancel) {
                dismiss()
            }
        } // 신고 완료 시 팝업
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    func checkInput() -> Bool {
        guard selectedReportItem != nil else { return false }
        guard content.count > 0 else { return false }
        
        return true
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
            .environmentObject(PostDetailViewModel())
    }
}
