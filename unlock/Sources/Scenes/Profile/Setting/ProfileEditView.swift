//
//  ProfileEditView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI
import Kingfisher

struct ProfileEditView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: SettingViewModel
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ProfileEditHeaderView()
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
                                    appState.forceErrorMessage("프로필 이미지 로딩에 실패했습니다.")
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
                                    .font(.semiBoldBody)
                                    .frame(width: 80, alignment: .leading)
                                VStack {
                                    TextField("이름", text: $viewModel.eName)
                                        .keyboardCleaned(keyboardType: .default, text: $viewModel.eName)
                                        .font(.lightBody)
                                    Divider()
                                }
                            }
                            HStack(alignment: .lastTextBaseline) {
                                Text("아이디")
                                    .font(.semiBoldBody)
                                    .frame(width: 80, alignment: .leading)
                                VStack {
                                    TextField("아이디", text: $viewModel.eUsername)
                                        .keyboardCleaned(keyboardType: .default, text: $viewModel.eUsername)
                                        .font(.lightBody)
                                    Divider()
                                }
                            }
                            HStack(alignment: .lastTextBaseline) {
                                Text("생년월일")
                                    .font(.semiBoldBody)
                                    .frame(width: 80, alignment: .leading)

                                VStack {
                                    TextField("생년월일", text: $viewModel.eBDay)
                                        .keyboardCleaned(keyboardType: .numberPad, text: $viewModel.eBDay, wordCount: 6)
                                        .font(.lightBody)
                                    Divider()
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("자기소개")
                                    .font(.semiBoldBody)

                                TextEditorApproachView(text: $viewModel.eBio, placeholder: "자기소개를 입력해주세요.", editorBackgroundColor: .gray1)
                            }
                            .padding(.top, 32)
                        }
                        .padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16))
                    }
                }
                .padding(.top, 16)
            }
            
            if let errorMessage = appState.errorMessage {
                ErrorPopupView(errorText: errorMessage)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setUpProfileEditData()
            viewModel.showCancelEditAlert(false)
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
            .environmentObject(AppState.shared)
            .environmentObject(SettingViewModel())
    }
}
