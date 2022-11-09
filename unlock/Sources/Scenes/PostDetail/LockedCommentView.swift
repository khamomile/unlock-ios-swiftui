//
//  LockedCommentView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct LockedCommentView: View {
    var body: some View {
        VStack {
            Image("closed-eye")
            Text("게시물이 잠겨있어요.\n댓글을 작성하여 열어봐요.")
                .font(.lightBody)
                .foregroundColor(.gray8)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 250)
    }
}

struct EmptyOrLockedCommentView_Previews: PreviewProvider {
    static var previews: some View {
        LockedCommentView()
    }
}
