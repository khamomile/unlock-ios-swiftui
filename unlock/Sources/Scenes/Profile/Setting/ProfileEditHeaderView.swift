//
//  ProfileEditHeaderView.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/01.
//

import SwiftUI

struct ProfileEditHeaderView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: SettingViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var goBackAlert: Bool = false
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                if viewModel.profileChanged() {
                    goBackAlert = true
                } else {
                    dismiss()
                }
            } label: {
                Image("angle-left")
            }
            
            Spacer()
            
            Text("프로필 수정")
                .font(.lightBody)
                .foregroundColor(.gray9)
            
            Spacer()
            
            Button {
                viewModel.profileChanged() ? viewModel.postEdit() : dismiss()
            } label: {
                Text("완료")
                    .font(.boldBody)
                    .foregroundColor(.gray9)
            }
            
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        .alert("프로필 편집을 취소할까요?", isPresented: $goBackAlert) {
            Button("네", role: .cancel) { dismiss() }
            Button("아니오", role: .destructive) { }
        }
        .alert("프로필 편집이 완료되었습니다.", isPresented: $viewModel.editSuccess) {
            Button("확인", role: .cancel) { dismiss() }
        }
    }
}

struct ProfileEditHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditHeaderView()
            .environmentObject(UnlockService.shared)
            .environmentObject(SettingViewModel())
    }
}
