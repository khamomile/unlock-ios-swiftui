//
//  RegisterOrLoginView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/28.
//

import SwiftUI

struct RegisterOrLoginView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @EnvironmentObject var unlockService: UnlockService
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("UNLOCK")
                    .font(.extraLightHeadline)
                    .foregroundColor(.gray9)
                
                Spacer()
                
                Image("keyhole")
                
                Spacer()
                
                Button {
                    
                } label: {
                    VStack(spacing: 5) {
                        NavigationLink {
                            EmailInputView()
                                .environmentObject(viewModel)
                        } label: {
                            Text("회원가입하기")
                                .font(.boldTitle1)
                                .foregroundColor(.gray8)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray2)
                    }
                    .fixedSize()
                    
                    
                }
                .padding(.bottom, 24)
                
                HStack(alignment: .lastTextBaseline, spacing: 5) {
                    Text("이미 계정이 있어서")
                        .font(.lightCaption3)
                        .foregroundColor(.gray5)
                    
                    NavigationLink {
                        LoginView()
                            .environmentObject(viewModel)
                    } label: {
                        Text("로그인 할래요")
                            .font(.lightCaption3)
                            .foregroundColor(.blue1)
                    }
                }
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        }
    }
}

struct RegisterOrLoginView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterOrLoginView()
            .environmentObject(SignInViewModel())
            .environmentObject(UnlockService.shared)
    }
}
