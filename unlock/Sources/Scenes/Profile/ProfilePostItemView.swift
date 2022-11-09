//
//  ProfilePostItemView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct ProfilePostItemView: View {
    @ObservedObject var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .font(.mediumBody)
                .foregroundColor(.gray7)
            Spacer()
            HStack(spacing: 0) {
                Text(post.updatedAt.format(with: "yyyy/MM/dd"))
                    .font(.regularCaption2)
                    .foregroundColor(.gray4)
                Spacer()
                
                Image("heart-small")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .padding(.trailing, 4)

                Text("\(post.likes)")
                    .font(.regularCaption2)
                    .foregroundColor(.gray5)
                    .padding(.trailing, 8)
                
                Image("comment-small")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .padding(.trailing, 4)
                
                Text("\(post.commentsCount)")
                    .font(.regularCaption2)
                    .foregroundColor(.gray5)
            }
        }
        .padding(EdgeInsets(top: 20, leading: 12, bottom: 12, trailing: 12))
        .frame(height: 120)
        .background(Color.gray0)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray1)
        }
    }
}

struct ProfilePostItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePostItemView(post: Post.preview)
    }
}
