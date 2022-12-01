//
//  FriendListView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: FriendViewModel = FriendViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            BasicHeaderView(text: "친구 목록")
            
            ScrollView {
                FriendRequestView()
                    .environmentObject(viewModel)
                
                MyFriendView()
                    .environmentObject(viewModel)
            }
            .refreshable {
                viewModel.getFriendList()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getFriendList()
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
