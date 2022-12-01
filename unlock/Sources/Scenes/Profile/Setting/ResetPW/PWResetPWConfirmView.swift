//
//  PWResetPWConfirmView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct PWResetPWConfirmView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: SettingViewModel
    
    enum FocusedField { case pw1, pw2 }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ZStack {
            VStack {
                BasicHeaderView(text: "비밀번호 변경")
                HStack(spacing: 0) {
                    Text("비밀번호를 ")
                        .underline()
                    Text("입력해주세요.")
                }
                .font(.boldHeadline)
                .foregroundColor(.gray9)
                .padding(EdgeInsets(top:80, leading: 0, bottom: 100, trailing: 0))
                
                VStack(alignment: .leading) {
                    SecureField(String("비밀번호를 입력해주세요"), text: $viewModel.newPassword1)
                        .keyboardCleaned(keyboardType: .default, text: $viewModel.newPassword1)
                        .focused($focusedField, equals: .pw1)
                        .font(.lightCaption1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)

                    if viewModel.newPassword1.count > 0 {
                        Text(Utils.inPWFormat(viewModel.newPassword1) ? "좋은 비밀번호에요" : "불가능한 비밀번호에요.")
                            .font(.lightCaption3)
                            .foregroundColor(Utils.inPWFormat(viewModel.newPassword1) ? .green1 : .red1)
                    }

                    SecureField(String("한 번 더 입력해주세요"), text: $viewModel.newPassword2)
                        .keyboardCleaned(keyboardType: .default, text: $viewModel.newPassword2)
                        .focused($focusedField, equals: .pw2)
                        .font(.lightCaption1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)

                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)

                    if viewModel.newPassword2.count > 0 {
                        Text(viewModel.newPassword1 == viewModel.newPassword2 ? "비밀번호가 일치해요" : "비밀번호가 일치하지 않아요.")
                            .font(.lightCaption3)
                            .foregroundColor(viewModel.newPassword1 == viewModel.newPassword2 ? .green1 : .red1)
                    }
                }
                .padding(.horizontal, 32)
                
                Button {
                    viewModel.putResetPassword(email: viewModel.resetEmail, code: viewModel.resetVFCode, newPW: viewModel.newPassword1)
                } label: {
                    if unlockService.isLoading {
                        ColoredProgressView(color: .gray)
                    } else {
                        Text("변경하기")
                            .font(.regularHeadline)
                            .foregroundColor(
                                viewModel.newPWValid ? .gray8 : .gray2
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
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 0, trailing: 32))
                .disabled(!viewModel.newPWValid)
                
                Text("""
    - 8~12자로 영문, 숫자, 특수문자를 사용하실 수 있습니다.
    - 한글과 공백은 사용하실 수 없습니다.
    - 영문 대소문자를 구분하니 꼭 확인해 주세요.
    - 아이디와 동일하게 설정할 수 없습니다.
    - 문자열, 연속 문자열 등 쉬운 비밀번호는 사용하지 마세요.
    """)
                .font(.regularCaption1)
                .foregroundColor(.gray5)
                .lineSpacing(7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(32)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            if let errorMessage = unlockService.errorMessage {
                ErrorPopupView(errorText: errorMessage)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            focusedField = .pw1
        }
        .onSubmit {
            if focusedField == .pw1 {
                focusedField = .pw2
            } else {
                focusedField = nil
                if viewModel.newPWValid {
                    viewModel.putResetPassword(email: viewModel.resetEmail, code: viewModel.resetVFCode, newPW: viewModel.newPassword1)
                }
            }
        }
        .alert("비밀번호 재설정이 완료되었습니다.\n로그인을 다시 해주시기 바랍니다.", isPresented: $viewModel.logoutSuccess) {
            Button("확인", role: .cancel) {
                viewModel.setMoveToMain(true)
            }
        }
        .fullScreenCover(isPresented: $viewModel.moveToMain) {
            UserInitialView()
        }
    }
}

struct PWResetPWConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        PWResetPWConfirmView()
            .environmentObject(UnlockService.shared)
            .environmentObject(SettingViewModel())
    }
}
