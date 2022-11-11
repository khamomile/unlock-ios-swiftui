//
//  LoginView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @EnvironmentObject var unlockService: UnlockService
    
    @State private var id: String = ""
    @State private var pw: String = ""
    
    enum FocusedField { case id, pw }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("UNLOCK")
                    .font(.extraLightHeadline)
                    .foregroundColor(.gray9)
                
                Spacer()
                
                VStack {
                    TextField(String("이메일을 입력해주세요"), text: $id)
                        .keyboardCleaned(keyboardType: .emailAddress, text: $id)
                        .focused($focusedField, equals: .id)
                        .font(.lightCaption1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)
                    
                    SecureField(String("비밀번호를 입력해주세요"), text: $pw)
                        .keyboardCleaned(keyboardType: .emailAddress, text: $pw)
                        .focused($focusedField, equals: .pw)
                        .font(.lightCaption1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                    Rectangle()
                        .foregroundColor(.gray1)
                        .frame(height: 1)
                }
                .padding(.horizontal, 32)
                
                Button {
                    viewModel.postLogin(email: id, password: pw)
                } label: {
                    if unlockService.isLoading {
                        ColoredProgressView(color: .gray)
                    } else {
                        Text("로그인")
                            .font(.regularHeadline)
                            .foregroundColor(
                                checkIdPw() ? .gray8 : .gray2
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
                .disabled(!checkIdPw() || unlockService.isLoading)
                
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        PWResetEmailView()
                    } label: {
                        Text("비밀번호를 모르겠어요")
                            .font(.lightCaption2)
                            .foregroundColor(.gray4)
                            .underline()
                            .padding(EdgeInsets(top: 10, leading: 32, bottom: 0, trailing: 32))
                    }
                }

                Spacer()
                
                HStack {
                    Link(destination: URL(string: "https://www.unlock.im/privacy.html")!, label: {
                        Text("개인정보처리방침")
                    })
                    Text("|")
                    Link(destination: URL(string: "https://polyester-ghoul-e62.notion.site/Unlock-b6ed1f758c0f41608f7a37ec8c6ce23f")!, label: {
                        Text("이용약관")
                    })
                    Text("|")
                    Link(destination: URL(string: "https://polyester-ghoul-e62.notion.site/Unlock-23ca9a66c9ec429ca4ccea2fb593a417")!, label: {
                        Text("커뮤니티 이용규칙")
                    })
                }
                .font(.lightCaption3)
                .foregroundColor(.gray4)
                .padding(.bottom, 10)
                
            }
            .frame(maxHeight: .infinity)
            .fullScreenCover(isPresented: $viewModel.loggedIn, content: {
                MainTabView()
            })
            .onTapGesture {
                focusedField = nil
            }
            
            if let errorMessage = unlockService.errorMessage {
                ErrorPopupView(errorText: errorMessage)
                    .zIndex(1)
            }
        }
        .navigationBarHidden(true)
        .onChange(of: unlockService.errorMessage, perform: { message in
            focusedField = nil
        })
        .onSubmit {
            if focusedField == .id {
                focusedField = .pw
            } else {
                focusedField = nil
                viewModel.postLogin(email: id, password: pw)
            }
        }
    }
    
    func checkIdPw() -> Bool {
        return id.count > 0 && pw.count > 0
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(SignInViewModel())
            .environmentObject(UnlockService.shared)
    }
}
