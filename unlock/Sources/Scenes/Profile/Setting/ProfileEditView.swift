//
//  ProfileEditView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI
import Kingfisher

struct ProfileEditView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: SettingViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var goBackAlert: Bool = false
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker: Bool = false
    
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var bday: String = ""
    @State private var bio: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                ProfileEditHeaderView(name: $name, username: $username, bday: $bday, bio: $bio)
                    .environmentObject(viewModel)
                
                ScrollView {
                    VStack {
                        if viewModel.isPostingImage {
                            ColoredProgressView(color: .gray)
                                .frame(width: 80, height: 80)
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray2)
                                })
                        } else {
                            KFImage(URL(string: viewModel.profileImageURL))
                                .placeholder {
                                    ColoredProgressView(color: .gray)
                                }
                                .retry(maxCount: 2, interval: .seconds(2))
                                .onFailure({ e in
                                    unlockService.forceErrorMessage("프로필 이미지 로딩에 실패했습니다.")
                                })
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray2)
                                })
                                .overlay(alignment: .bottomTrailing) {
                                    Image("camera")
                                        .background(.blue)
                                        .clipShape(Circle())
                                        .offset(CGSize(width: -5.0, height: -5.0))
                                }
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack(alignment: .lastTextBaseline) {
                                Text("이름")
                                    .keyboardCleaned(keyboardType: .default, text: $name)
                                    .font(.semiBoldBody)
                                    .frame(width: 80, alignment: .leading)
                                VStack {
                                    TextField("이름", text: $name)
                                        .font(.lightBody)
                                    Divider()
                                }
                            }
                            HStack(alignment: .lastTextBaseline) {
                                Text("아이디")
                                    .keyboardCleaned(keyboardType: .default, text: $username)
                                    .font(.semiBoldBody)
                                    .frame(width: 80, alignment: .leading)
                                VStack {
                                    TextField("아이디", text: $username)
                                        .font(.lightBody)
                                    Divider()
                                }
                            }
                            HStack(alignment: .lastTextBaseline) {
                                Text("생년월일")
                                    .keyboardCleaned(keyboardType: .numberPad, text: $bday, wordCount: 6)
                                    .font(.semiBoldBody)
                                    .frame(width: 80, alignment: .leading)
                                VStack {
                                    TextField("생년월일", text: $bday)
                                        .font(.lightBody)
                                    Divider()
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("자기소개")
                                    .font(.semiBoldBody)
                                TextEditorApproachView(text: $bio, placeholder: "자기소개를 입력해주세요.", editorBackgroundColor: .gray1)
                            }
                            .padding(.top, 32)
                        }
                        .padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16))
                    }
                }
                .padding(.top, 16)
            }
            
            if let errorMessage = unlockService.errorMessage {
                ErrorPopupView(errorText: errorMessage)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            name = viewModel.fullname
            username = viewModel.username
            bday = viewModel.bDay
            bio = viewModel.bio
        }
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(image: $inputImage)
        })
        .onChange(of: inputImage, perform: { _ in
            loadImage()
            viewModel.postImage(file: (inputImage?.jpegData(compressionQuality: 0.8))!)
        })
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
            .environmentObject(UnlockService.shared)
            .environmentObject(SettingViewModel())
    }
}
