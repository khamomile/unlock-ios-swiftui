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
    
    var body: some View {
        ZStack {
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
                            .keyboardCleaned(keyboardType: .default, text: $keyword)
                            .focused($isFocused)
                            .font(.lightCaption1)
                        
                        Image("close-input")
                            .onTapGesture {
                                keyword = ""
                                isFocused = false
                            }
                    }
                    .padding(8)
                    .background(Color.gray0)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding()
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        if keyword.count < 2 {
                            Color.white
                                .frame(height: geometry.size.height)
                        } else if keyword.count >= 2 && viewModel.userList.count == 0 {
                            EmptySearchView()
                                .frame(height: geometry.size.height)
                        } else {
                            ForEach(viewModel.userList) { user in
                                SearchItemView(user: user, isFocused: _isFocused)
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                    .onTapGesture {
                        isFocused = false
                    }
                }
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
            
            if unlockService.showPopup {
                if let doublePopupToShow = unlockService.doublePopupToShow {
                    DoublePopupView(doublePopupInfo: doublePopupToShow)
                        .zIndex(1)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
