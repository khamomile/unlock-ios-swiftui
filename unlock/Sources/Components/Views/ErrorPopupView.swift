//
//  ErrorPopupView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/29.
//

import SwiftUI

struct ErrorPopupView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var appState: AppState = AppState.shared
    
    var errorText: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            
            VStack(spacing: 0) {
                Spacer()
                
                Text(errorText)
                    .font(.lightCaption1)
                    .foregroundColor(.gray9)
                    .padding(.top, 16)
                
                Spacer()
                
                Divider()
                    .padding(.horizontal, 16)
                
                Button {
                    withAnimation(.default) {
                        appState.errorMessage = nil
                    }
                } label: {
                    Text("확인")
                        .font(.boldBody)
                        .foregroundColor(.gray9)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
            .frame(width: 320, height: 220)
            .background(Color.white)
        }
        .ignoresSafeArea()
    }
}

struct ErrorPopupView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorPopupView(errorText: "신고가 완료되었습니다.")
    }
}
