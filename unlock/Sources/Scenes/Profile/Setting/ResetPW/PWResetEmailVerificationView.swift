//
//  PWResetEmailVerificationView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct PWResetEmailVerificationView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: SettingViewModel
    
    @State var timeRemaining = 300
    @State var selection: Int? = nil
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                BasicHeaderView(text: "비밀번호 변경")
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
                        TextField("인증번호", text: $viewModel.resetVFCode)
                            .keyboardCleaned(keyboardType: .numberPad, text: $viewModel.resetVFCode, wordCount: 5)
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
                } label: {
                    Text("인증번호 재전송")
                        .font(.lightCaption2)
                        .foregroundColor(.gray4)
                        .underline()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(EdgeInsets(top: 10, leading: 32, bottom: 0, trailing: 32))
                }
                
                Button {
                    viewModel.postCheckEmailCode(email: viewModel.resetEmail, code: viewModel.resetVFCode)
                } label: {
                    if unlockService.isLoading {
                        ColoredProgressView(color: .gray)
                    } else {
                        Text("다음")
                            .font(.regularHeadline)
                            .foregroundColor(
                                Utils.inVerificationFormat(viewModel.resetVFCode) ? .gray8 : .gray2
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
                .disabled(!Utils.inVerificationFormat(viewModel.resetVFCode))
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .navigationDestination(isPresented: $viewModel.emailVerified) {
                PWResetPWConfirmView()
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
            if Utils.inVerificationFormat(viewModel.resetVFCode) {
                viewModel.postCheckEmailCode(email: viewModel.resetEmail, code: viewModel.resetVFCode)
            }
        }
    }
}

struct PWResetEmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        PWResetEmailVerificationView()
            .environmentObject(UnlockService.shared)
            .environmentObject(SettingViewModel())
    }
}
