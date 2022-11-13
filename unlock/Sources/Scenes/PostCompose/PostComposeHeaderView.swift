//
//  PostComposeHeaderView.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/13.
//

import SwiftUI

struct PostComposeHeaderView: View {
    @EnvironmentObject var viewModel: PostComposeViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var titleText: String
    @Binding var contentText: String
    @Binding var showPublic: PostPublicStatus
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 15) {
                Button {
                    dismiss()
                } label: {
                    Image("angle-left")
                }
                
                Spacer()
                
                Button {
                    if let postToEdit = viewModel.postToEdit {
                        viewModel.putPost(id: postToEdit.id, title: titleText, content: contentText, showPublic: showPublic.boolValue, images: viewModel.images)
                    } else {
                        viewModel.postPost(title: titleText, content: contentText, showPublic: showPublic.boolValue, images: viewModel.images)
                    }
                } label: {
                    Text("완료")
                        .font(.boldBody)
                        .foregroundColor(contentsFilled() ? .gray9 : .gray1)
                }
                .disabled(!contentsFilled())
            }
            
            Text("글쓰기")
                .font(.lightBody)
                .foregroundColor(.gray9)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    func contentsFilled() -> Bool {
        return titleText.count > 0 && contentText.count > 0
    }
}

struct PostComposeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PostComposeHeaderView(titleText: .constant("제목"), contentText: .constant("내용"), showPublic: .constant(.isPublic))
            .environmentObject(PostComposeViewModel())
    }
}
