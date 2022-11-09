//
//  EmailVerificationView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @EnvironmentObject var unlockService: UnlockService
    
    @State private var code: String = ""
    @FocusState private var isFocused: Bool
    
    @State var timeRemaining = 300
    @State var selection: Int? = nil
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("이메일로 보내진")
                    HStack(spacing: 0) {
                        Text("인증번호를")
                            .underline()
                        Text(" 입력해주세요.")
                    }
                }
                .font(.boldHeadline)
                .foregroundColor(.gray9)
                .padding(EdgeInsets(top: 80, leading: 0, bottom: 100, trailing: 0))
                
                VStack {
                    HStack(alignment: .lastTextBaseline) {
                        TextField("인증번호", text: $code)
                            .keyboardCleaned(keyboardType: .numberPad, text: $code, wordCount: 5)
                            .focused($isFocused)
                            .font(.lightCaption1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(Utils.secondsToMinuteSecond(timeRemaining))")
                            .font(.semiBoldCaption1)
                            .foregroundColor(.gray5)
                            .onReceive(timer) { _ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }
                    }
                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)
                }
                .padding(.horizontal, 32)
                
                Button {
                    timeRemaining = 300
                    viewModel.postSendEmailCode(email: viewModel.email)
                } label: {
                    Text("인증번호 재전송")
                        .font(.lightCaption2)
                        .foregroundColor(.gray4)
                        .underline()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(EdgeInsets(top: 10, leading: 32, bottom: 0, trailing: 32))
                }
                
                Button {
                    viewModel.postCheckEmailCode(email: viewModel.email, code: code)
                } label: {
                    if unlockService.isLoading {
                        ColoredProgressView(color: .gray)
                    } else {
                        Text("다음")
                            .font(.regularHeadline)
                            .foregroundColor(
                                Utils.inVerificationFormat(code) ? .gray8 : .gray2
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
                .disabled(!Utils.inVerificationFormat(code) || unlockService.isLoading)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .navigationDestination(isPresented: $viewModel.emailVerified, destination: {
                IDInputView()
            })
            
            if let errorMessage = unlockService.errorMessage {
                ErrorPopupView(errorText: errorMessage)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
        .onSubmit {
            if Utils.inVerificationFormat(code) {
                viewModel.postCheckEmailCode(email: viewModel.email, code: code)
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    unlockService.errorMessage = "올바른 형식의 인증코드를 입력해주세요."
                }
            }
        }
    }
}

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationView()
            .environmentObject(SignInViewModel())
            .environmentObject(UnlockService.shared)
    }
}
