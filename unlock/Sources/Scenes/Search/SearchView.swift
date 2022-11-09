//
//  SearchView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var unlockService: UnlockService
    @StateObject var viewModel: FriendViewModel = FriendViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var keyword: String = ""
    @FocusState var isFocused: Bool
    
    struct Number: Identifiable {
        let value: Int
        var id: Int { value }
    }
    
    let numbers: [Number] = (0...5).map { Number(value: $0) }
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Button {
                    dismiss()
                } label: {
                    Image("angle-left")
                }

                HStack {
                    Image("search-grey")
                    
                    TextField("아이디 또는 이름으로 검색", text: $keyword)
                        .focused($isFocused)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.lightCaption1)
                    
                    Image("close-input")
                        .onTapGesture {
                            keyword = ""
                        }
                }
                .padding(8)
                .background(Color.gray0)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding()
            
            GeometryReader { geometry in
                ScrollView {
                    if keyword.count >= 2 && viewModel.userList.count == 0 {
                        EmptySearchView()
                            .frame(height: geometry.size.height)
                    } else {
                        ForEach(viewModel.userList) { user in
                            SearchItemView(user: user)
                                .environmentObject(viewModel)
                        }
                    }
                }
                .padding(.bottom, 16)
                .onTapGesture {
                    isFocused = false
                }
            }
            // InviteFriendSearchView()
        }
        .navigationBarHidden(true)
        .onChange(of: keyword) { newKeyword in
            if newKeyword.count >= 2 {
                viewModel.getUserList(keyword: newKeyword)
            } else if newKeyword.count < 2 {
                viewModel.userList = []
            }
        }
        .onAppear {
            isFocused = true
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
