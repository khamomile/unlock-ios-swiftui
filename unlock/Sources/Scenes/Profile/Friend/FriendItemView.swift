//
//  FriendItemView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI
import Kingfisher

struct FriendItemView: View {
    @EnvironmentObject var viewModel: FriendViewModel
    
    var friend: User
    var isRequest: Bool = false

    @State private var showStoreDropDown: Bool = false
    @State private var myZindex: Double = 1
    
    var body: some View {
        HStack(spacing: 14) {
            KFImage(URL(string: friend.profileImage))
                .placeholder {
                    Color.gray1
                }
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 42, height: 42)
            
            VStack(alignment: .leading) {
                Text(friend.username)
                    .font(.semiBoldBody)
                    .foregroundColor(.gray8)
                Text(friend.fullname)
                    .font(.regularCaption1)
                    .foregroundColor(.gray5)
            }
            
            Spacer()
            
            if isRequest {
                Image("check-green")
                    .onTapGesture {
                        viewModel.patchFriend(id: friend.id)
                    }
                
                Image("close")
                    .onTapGesture {
                        viewModel.deleteFriend(id: friend.id)
                    }
            } else {
                Image("dots-vertical")
                    .onTapGesture {
                        showStoreDropDown.toggle()
                        myZindex = myZindex == 10 ? 1 : 10
                    }
                    .overlay (
                        VStack {
                            if showStoreDropDown {
                                Spacer(minLength: 20)
                                
                                SampleDropDown(buttonInfo: getDropdownButtonInfo())
                                    .offset(CGSize(width: -11.0, height: 5.0))
                            }
                        }.animation(.easeInOut, value: showStoreDropDown), alignment: .topTrailing
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
        .zIndex(myZindex)
    }
    
    func getDropdownButtonInfo() -> [CustomButtonInfo] {
        let buttonInfo1 = CustomButtonInfo(title: "친구삭제", btnColor: .red1) {
            viewModel.deleteFriend(id: friend.id)
        }
        
        return [buttonInfo1]
    }
}

struct FriendItemView_Previews: PreviewProvider {
    static var previews: some View {
        FriendItemView(friend: User())
            .environmentObject(FriendViewModel())
    }
}
