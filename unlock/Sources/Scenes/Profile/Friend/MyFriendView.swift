//
//  MyFriendView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct MyFriendView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: FriendViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("친구 \(viewModel.friendList.count)명")
                .font(.mediumBody)
                .padding(.horizontal, 16)
                .foregroundColor(.gray9)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                if viewModel.isLoadingMyFriend {
                    ColoredProgressView(color: .gray)
                        .frame(maxHeight: .infinity)
                } else {
                    if viewModel.friendList.count == 0 {
                        InviteFriendSearchView()
                            .padding(.top, 100)
                    } else {
                        VStack {
                            ForEach(viewModel.friendList) { friend in
                                FriendItemView(friend: friend)
                            }
                        }
                        .animation(.default, value: viewModel.friendList)
                    }
                }
            }
            .animation(.default, value: viewModel.isLoadingMyFriend)
        }
        .padding(.vertical, 16)
        
    }
}

struct MyFriendView_Previews: PreviewProvider {
    static var previews: some View {
        MyFriendView()
            .environmentObject(AppState.shared)
            .environmentObject(FriendViewModel())
    }
}
