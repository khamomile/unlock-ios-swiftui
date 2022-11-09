//
//  ProfilePostView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct ProfilePostView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: ProfileViewModel
    
    @Binding var path: NavigationPath
    
    struct Number: Identifiable {
        let value: Int
        var id: Int { value }
    }
    
    let numbers: [Number] = (0...8).map { Number(value: $0) }
    
    private let columns = [
        GridItem(.fixed(UIScreen.main.bounds.width/2 - 16), spacing: nil, alignment: .leading),
        GridItem(.fixed(UIScreen.main.bounds.width/2 - 16), spacing: nil, alignment: .leading)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            if unlockService.isLoading {
                ColoredProgressView(color: .gray)
            } else {
                if viewModel.myPosts.count == 0 {
                    ProfilePostEmptyView()
                        .padding(.bottom, 100)
                } else {
                    Text("내 게시물")
                        .font(.boldBody)
                        .foregroundColor(.gray8)
                        .padding(EdgeInsets(top: 40, leading: 16, bottom: 0, trailing: 40))
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.myPosts) { post in
                            NavigationLink(value: post.id) {
                                ProfilePostItemView(post: post)
                            }
                        }
                    }
                }
            }
        }
        .navigationDestination(for: String.self) { postId in
            PostDetailView(path: $path, postID: postId)
                .environmentObject(viewModel)
        }
    }
}

struct ProfilePostView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePostView(path: .constant(NavigationPath()))
            .environmentObject(UnlockService.shared)
            .environmentObject(ProfileViewModel())
    }
}
