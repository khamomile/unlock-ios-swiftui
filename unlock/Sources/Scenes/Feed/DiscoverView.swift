//
//  DiscoverView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject var viewModel: DiscoverFeedViewModel = DiscoverFeedViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SimpleHeaderView(title: "Discover")

                ZStack(alignment: .bottomTrailing) {
                    Color(.init(gray: 0.9, alpha: 0.5))
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(Array(viewModel.postList.enumerated()), id: \.element.id) { idx, post in
                                NavigationLink {
                                    PostDetailView(path: .constant(NavigationPath()), postID: post.id)
                                } label: {
                                    PostItemView(path: .constant(NavigationPath()), post: post)
                                }
                                .onAppear {
                                    print("Index: \(idx)", "Total index: \(viewModel.postList.count)")
                                    if idx == viewModel.postList.count - 1 {
                                        print("Index: \(idx)", "Total index: \(viewModel.postList.count)", "EXECUTED")
                                        if viewModel.pageNo <= viewModel.totalPageNo + 1 {
                                            if viewModel.newPageUpdated {
                                                viewModel.getNextPages(nextPageNo: viewModel.pageNo)
                                            } else {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                    viewModel.getNextPages(nextPageNo: viewModel.pageNo)
                                                }
                                            }

                                            print("Index: \(idx)", "Total index: \(viewModel.postList.count)", "EXECUTED22")
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .refreshable {
                        viewModel.refreshPages()
                    }
                    NavigationLink {
                        PostComposeView(path: .constant(NavigationPath()))
                    } label: {
                        Image("pencil")
                            .padding()
                            .background(Circle().fill(Color.gray9.opacity(0.8)))
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
            }
            .toolbar(.visible, for: .tabBar)
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
