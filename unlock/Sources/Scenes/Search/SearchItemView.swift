//
//  SearchItemView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI
import Kingfisher

struct SearchItemView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: FriendViewModel
    
    @State private var showStoreDropDown: Bool = false
    
    var user: User
    
    @State private var myZindex: Double = 1
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            KFImage(URL(string: user.profileImage))
                .placeholder {
                    Color.gray1
                }
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 42, height: 42)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.semiBoldBody)
                    .foregroundColor(.gray8)
                Text(user.fullname)
                    .font(.regularCaption1)
                    .foregroundColor(.gray5)
            }
            
            Spacer()
            
            if viewModel.userStatusList[user]!.0 == .noRelationship {
                Image("friend-plus-green")
                    .onTapGesture {
                        viewModel.postRequestFriend(id: user.id)
                    }
            } else if viewModel.userStatusList[user]!.0 == .isFriend {
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
            } else if viewModel.userStatusList[user]!.0 == .waitingAccept {
                if viewModel.userStatusList[user]!.1 == true {
                    Image("check-green")
                        .onTapGesture {
                            viewModel.patchFriend(id: user.id)
                        }
                    
                    Image("close")
                        .onTapGesture {
                            viewModel.deleteFriend(id: user.id)
                        }
                } else {
                    Image("friend-plus-grey")
                        .onTapGesture {
                            viewModel.deleteFriend(id: user.id)
                        }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
        .zIndex(myZindex)
    }
    
    func getDropdownButtonInfo() -> [CustomButtonInfo] {
        let buttonInfo1 = CustomButtonInfo(title: "친구삭제", btnColor: .red1) {
            unlockService.setDoublePopup(.deleteFriend(leftAction: nil, rightAction: { viewModel.deleteFriend(id: user.id) }, userFullname: user.fullname))
            isFocused = false
        }
        
        return [buttonInfo1]
    }
}

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchItemView(user: User())
            .environmentObject(UnlockService.shared)
            .environmentObject(FriendViewModel())
    }
}
