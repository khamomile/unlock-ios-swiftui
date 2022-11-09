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
    
    @Binding var name: String
    @Binding var username: String
    @Binding var bday: String
    @Binding var bio: String
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                if profileChanged() {
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
                handleEdit()
            } label: {
                Text("완료")
                    .font(.boldBody)
                    .foregroundColor(.gray9)
            }
            
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        .alert("프로필 편집을 취소할까요?", isPresented: $goBackAlert) {
            Button("네", role: .cancel) {
                dismiss()
            }
            Button("아니오", role: .destructive) { }
        }
        .alert("프로필 편집이 완료되었습니다.", isPresented: $viewModel.editSuccess) {
            Button("확인", role: .cancel) {
                dismiss()
            }
        }
    }
    
    func profileChanged() -> Bool {
        let condition1 = viewModel.profileImageURL != unlockService.me.profileImage
        let condition2 = name != viewModel.fullname
        let condition3 = username != viewModel.username
        let condition4 = bday != viewModel.bDay
        let condition5 = bio != viewModel.bio
        
        return condition1 || condition2 || condition3 || condition4 || condition5
    }
    
    func handleEdit() {
        if profileChanged() {
            viewModel.username = username
            viewModel.fullname = name
            viewModel.bDay = bday
            viewModel.bio = bio
            
            if username != viewModel.username {
                if Utils.inIDFormat(username) {
                    viewModel.postCheckUsernameDuplicate(username: username)
                } else {
                    unlockService.forceErrorMessage("5글자 이상 20글자 이하의 아이디를 입력해주세요.")
                }
            } else {
                viewModel.usernameVerified = true
            }
        } else {
            dismiss()
        }
    }
}

struct ProfileEditHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditHeaderView(name: .constant("이종인"), username: .constant("paullee20204"), bday: .constant("011105"), bio: .constant("날씨 좋다~"))
            .environmentObject(UnlockService.shared)
            .environmentObject(SettingViewModel())
    }
}
