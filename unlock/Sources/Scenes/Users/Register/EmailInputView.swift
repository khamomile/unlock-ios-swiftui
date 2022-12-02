//
//  EmailInputView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct EmailInputView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @EnvironmentObject var appState: AppState
    
    @State private var email: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        CustomZStackView {
            VStack {
                VStack {
                    Text("서비스에서 사용할")
                    HStack(spacing: 0) {
                        Text("이메일을")
                            .underline()
                        Text(" 입력해주세요.")
                    }
                }
                .font(.boldHeadline)
                .foregroundColor(.gray9)
                .padding(EdgeInsets(top: 80, leading: 0, bottom: 100, trailing: 0))

                VStack {
                    TextField(String("예) minds@unlock.im"), text: $email)
                        .font(.lightCaption1)
                        .keyboardCleaned(keyboardType: .emailAddress, text: $email)
                        .focused($isFocused)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)
                }
                .padding(.horizontal, 32)

                Button {
                    viewModel.postSendEmailCode(email: email)
                } label: {
                    if appState.isLoading {
                        ColoredProgressView(color: .gray)
                    } else {
                        Text("다음")
                            .font(.regularHeadline)
                            .foregroundColor(
                                Utils.inEmailFormat(email) ? .gray8 : .gray2
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
                .disabled(!Utils.inEmailFormat(email) || appState.isLoading)

                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .navigationDestination(isPresented: $viewModel.sentEmail, destination: {
            EmailVerificationView()
                .environmentObject(viewModel)
        })
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
        .onSubmit {
            if Utils.inEmailFormat(email) {
                viewModel.postSendEmailCode(email: email)
            }
        }
    }
}

struct EmailInputView_Previews: PreviewProvider {
    static var previews: some View {
        EmailInputView()
            .environmentObject(SignInViewModel())
            .environmentObject(AppState.shared)
    }
}
