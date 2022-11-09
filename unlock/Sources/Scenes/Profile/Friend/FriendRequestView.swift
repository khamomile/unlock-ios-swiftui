//
//  FriendRequestView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct FriendRequestView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: FriendViewModel
    
    struct Number: Identifiable {
        let value: Int
        var id: Int { value }
    }
    
    let numbers: [Number] = (0...2).map { Number(value: $0) }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("친구 요청")
                .font(.mediumBody)
                .foregroundColor(.gray9)
                .padding(.horizontal, 16)
            
            VStack {
                if viewModel.friendRequestList.count == 0 {
                    Text("요청이 없어요.")
                        .font(.lightCaption2)
                        .foregroundColor(.gray6)
                        .padding(16)
                } else {
                    ForEach(viewModel.friendRequestList) { requestedUser in
                        FriendItemView(friend: requestedUser, isRequest: true)
                    }
                }
            }
            .animation(.default, value: viewModel.friendRequestList)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView()
            .environmentObject(UnlockService.shared)
            .environmentObject(FriendViewModel())
    }
}
