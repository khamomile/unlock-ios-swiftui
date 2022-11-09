//
//  DoublePopupView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct DoublePopupView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var unlockService: UnlockService = UnlockService.shared
    
    var mainText: String
    
    var leftOptionText: String = "취소"
    var rightOptionText: String = "확인"
    
    var leftAction: (() -> Void)?
    var rightAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            
            VStack(spacing: 0) {
                Spacer()
                Text(mainText)
                    .font(.lightCaption1)
                    .foregroundColor(.gray9)
                    .padding(.top, 16)
                Spacer()
                Divider()
                    .padding(.horizontal, 16)
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            unlockService.showPopup = false
                        }
                        
                        if let leftAction = leftAction {
                            leftAction()
                        }
                    } label: {
                        Text(leftOptionText)
                            .font(.boldBody)
                            .foregroundColor(.red1)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            unlockService.showPopup = false
                        }
                        
                        if let rightAction = rightAction {
                            rightAction()
                        }
                    } label: {
                        Text(rightOptionText)
                            .font(.boldBody)
                            .foregroundColor(.gray9)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }

            }
            .frame(width: 320, height: 220)
            .background(Color.white)
        }
        .ignoresSafeArea()
    }
}

struct DoublePopupView_Previews: PreviewProvider {
    static var previews: some View {
        DoublePopupView(mainText: "계정을 탈퇴할까요?")
    }
}
