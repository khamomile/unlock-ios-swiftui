//
//  IDInputView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct IDInputView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @EnvironmentObject var appState: AppState
    
    @State private var username: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 0) {
                    Text("아이디를 ")
                        .underline()
                    Text("입력해주세요.")
                }
                .font(.boldHeadline)
                .foregroundColor(.gray9)
                .padding(EdgeInsets(top: 80, leading: 0, bottom: 100, trailing: 0))
                
                VStack {
                    TextField(String("5-20자 이내의 아이디"), text: $username)
                        .keyboardCleaned(keyboardType: .default, text: $username)
                        .focused($isFocused)
                        .font(.lightCaption1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)
                }
                .padding(.horizontal, 32)
                
                Button {
                    viewModel.postCheckUsernameDuplicate(username: username)
                } label: {
                    if appState.isLoading {
                        ColoredProgressView(color: .gray)
                    } else {
                        Text("다음")
                            .font(.regularHeadline)
                            .foregroundColor(
                                Utils.inIDFormat(username) ? .gray8 : .gray2
                            )
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray2)
                }
                .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 32))
                .disabled(!Utils.inIDFormat(username))
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .navigationDestination(isPresented: $viewModel.usernameVerified, destination: {
                PWInputView()
                    .environmentObject(viewModel)
            })
            
            if let errorMessage = appState.errorMessage {
                ErrorPopupView(errorText: errorMessage)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
        .onSubmit {
            if Utils.inIDFormat(username) {
                viewModel.postCheckUsernameDuplicate(username: username)
            }
        }
    }
}

struct IDInputView_Previews: PreviewProvider {
    static var previews: some View {
        IDInputView()
            .environmentObject(SignInViewModel())
            .environmentObject(AppState.shared)
    }
}
