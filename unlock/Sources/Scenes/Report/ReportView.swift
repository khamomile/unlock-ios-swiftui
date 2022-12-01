//
//  ReportView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: ReportViewModel = ReportViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var postID: String? = nil
    var commentID: String? = nil
    
    @State private var content: String = ""
    @State private var selectedReportItem: ReportItem?
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                BasicHeaderView(text: "신고하기")
                
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("신고사유를 선택해주세요.")
                                .font(.boldBody)
                                .foregroundColor(.gray8)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            ForEach(ReportItem.allCases) { reportItem in
                                Button {
                                    selectedReportItem = reportItem
                                    isFocused = false
                                } label: {
                                    Image(selectedReportItem == reportItem ? "checkbox-checked" : "checkbox")
                                    Text(reportItem.description)
                                        .font(.mediumBody)
                                        .foregroundColor(.gray7)
                                }
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.bottom, 40)

                        Text("신고내용을 작성해주세요.")
                            .font(.boldBody)
                            .foregroundColor(.gray8)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextEditorApproachView(text: $content, isFocused: _isFocused, placeholder: "예) 위협적인 발언으로 보여 신고합니다.", editorBackgroundColor: .gray1)
                            .padding(.horizontal, 16)
                        
                        Button {
                            appState.setDoublePopup(.report(leftAction: nil, rightAction: {
                                viewModel.report(reason: selectedReportItem?.option ?? 0, content: content)
                            }, reportType: viewModel.reportType))
                            
                            isFocused = false
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
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .alert(viewModel.reportSuccessAlertText, isPresented: $viewModel.reportSuccess) {
                Button("확인", role: .cancel) {
                    dismiss()
                }
            }
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
                viewModel.setPostAndCommentID(postID: postID, commentID: commentID)
            }
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .tabBar)
            
            if appState.showPopup {
                if let doublePopupToShow = appState.doublePopupToShow {
                    DoublePopupView(doublePopupInfo: doublePopupToShow)
                        .zIndex(1)
                }
            }
        }
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
            .environmentObject(AppState.shared)
            .environmentObject(PostDetailViewModel())
    }
}
