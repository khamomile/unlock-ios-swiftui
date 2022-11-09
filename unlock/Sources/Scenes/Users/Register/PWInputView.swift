//
//  PWInputView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct PWInputView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @EnvironmentObject var unlockService: UnlockService
    
    @State private var pw1: String = ""
    @State private var pw2: String = ""
    
    enum FocusedField { case pw1, pw2 }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 0) {
                    Text("비밀번호를 ")
                        .underline()
                    Text("입력해주세요.")
                }
                .font(.boldHeadline)
                .foregroundColor(.gray9)
                .padding(EdgeInsets(top:80, leading: 0, bottom: 100, trailing: 0))
                
                VStack(alignment: .leading) {
                    SecureField(String("비밀번호를 입력해주세요"), text: $pw1)
                        .keyboardCleaned(keyboardType: .default, text: $pw1)
                        .focused($focusedField, equals: .pw1)
                        .font(.lightCaption1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)
                    if pw1.count > 0 {
                        Text(inPWFormat(pw1) ? "좋은 비밀번호에요" : "불가능한 비밀번호에요.")
                            .font(.lightCaption3)
                            .foregroundColor(inPWFormat(pw1) ? .green1 : .red1)
                    }
                    SecureField(String("한 번 더 입력해주세요"), text: $pw2)
                        .keyboardCleaned(keyboardType: .default, text: $pw2)
                        .focused($focusedField, equals: .pw2)
                        .font(.lightCaption1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)
                    if pw2.count > 0 {
                        Text(pw1 == pw2 ? "비밀번호가 일치해요" : "비밀번호가 일치하지 않아요.")
                            .font(.lightCaption3)
                            .foregroundColor(pw1 == pw2 ? .green1 : .red1)
                    }
                }
                .padding(.horizontal, 32)
                
                Button {
                    viewModel.setPW(password: pw1)
                } label: {
                    Text("다음")
                        .font(.regularHeadline)
                        .foregroundColor(
                            inPWFormat(pw1) && pw1 == pw2 ? .gray8 : .gray2
                        )
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray2)
                }
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 0, trailing: 32))
                .disabled(!inPWFormat(pw1) || pw1 != pw2)
                
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
            .navigationDestination(isPresented: $viewModel.passwordVerified, destination: {
                ProfileInputView()
                    .environmentObject(viewModel)
            })
            
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
                if inPWFormat(pw1) && pw1 == pw2 {
                    viewModel.setPW(password: pw1)
                } else {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        unlockService.errorMessage = "올바른 형식의 비밀번호를 입력해주세요."
                    }
                }
            }
        }
    }
    
    func inPWFormat(_ text: String) -> Bool {
        let cs = CharacterSet.alphanumerics.inverted
        
        guard text.count >= 8 && text.count <= 12 else { return false }
        
        guard text.rangeOfCharacter(from: cs) == nil else {
            return false
        }
        
        return true
    }
}

struct PWInputView_Previews: PreviewProvider {
    static var previews: some View {
        PWInputView()
            .environmentObject(SignInViewModel())
            .environmentObject(UnlockService.shared)
    }
}
