//
//  PWResetEmailView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct PWResetEmailView: View {
    @EnvironmentObject var unlockService: UnlockService
    @StateObject var viewModel = SettingViewModel()
    
    @State private var email: String = ""
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        //  Text("서비스에서 사용할\n") + Text("이메일").underline() + Text("을 입력해주세요.")
        ZStack {
            VStack {
                BasicHeaderView(text: "비밀번호 변경")
                VStack {
                    Text("어떤 이메일을 사용하셨나요?")
                }
                .font(.boldHeadline)
                .foregroundColor(.gray9)
                .padding(EdgeInsets(top: 80, leading: 0, bottom: 100, trailing: 0))
                
                VStack {
                    TextField(String("예) minds@unlock.im"), text: $email)
                        .keyboardCleaned(keyboardType: .emailAddress, text: $email)
                        .focused($isFocused)
                        .font(.lightCaption1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)
                }
                .padding(.horizontal, 32)
                
                Button {
                    viewModel.postCheckEmailDuplicate(email: email)
                } label: {
                    if unlockService.isLoading {
                        ColoredProgressView(color: .gray)
                    } else {
                        Text("비밀번호 재설정")
                            .font(.regularHeadline)
                            .foregroundColor(
                                Utils.inEmailFormat(email) ? .gray8 : .gray2
                            )
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                            .frame(maxWidth: .infinity)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray2)
                }
                .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 32))
                .disabled(!Utils.inEmailFormat(email))
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .navigationDestination(isPresented: $viewModel.resetEmailSent) {
                PWResetEmailVerificationView()
                    .environmentObject(viewModel)
            }
            
            if let errorMessage = unlockService.errorMessage {
                ErrorPopupView(errorText: errorMessage)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
        .onSubmit {
            if Utils.inEmailFormat(email) {
                viewModel.postCheckEmailDuplicate(email: email)
            }
        }
    }
}

struct PWResetEmailView_Previews: PreviewProvider {
    static var previews: some View {
        PWResetEmailView()
            .environmentObject(UnlockService.shared)
    }
}