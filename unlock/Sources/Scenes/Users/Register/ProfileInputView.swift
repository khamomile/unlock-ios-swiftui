//
//  ProfileInputView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

enum Gender: String {
    case male = "male"
    case female = "female"
    case others = "others"
}

struct ProfileInputView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @EnvironmentObject var appState: AppState
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker: Bool = false
    
    @State private var name: String = ""
    @State private var bday: String = ""
    
    @State private var genderSelected: Gender?
    
    @State private var usageAgreementChecked: Bool = false
    @State private var privacyChecked: Bool = false
    @State private var communityGuidelineChecked: Bool = false
    
    enum FocusedField { case name, bday }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    VStack {
                        Text("프로필 사진을\n 선택해주세요!")
                            .font(.boldHeadline)
                            .foregroundColor(.gray9)
                            .multilineTextAlignment(.center)
                        Button {
                            showingImagePicker = true
                        } label: {
                            if let image = image {
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                Image("plus")
                                    .resizable()
                                    .padding(20)
                                    .frame(width: 80, height: 80)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray2)
                                    }
                            }
                        }
                    }
                    .padding(.top, 80)
                    
                    VStack(alignment: .leading) {
                        Text("이름")
                            .font(.semiBoldHeadline)
                            .foregroundColor(.gray9)
                        TextField(String("이름을 입력해주세요"), text: $name)
                            .keyboardCleaned(keyboardType: .default, text: $name)
                            .focused($focusedField, equals: .name)
                            .font(.lightCaption1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle()
                            .foregroundColor(.gray1)
                            .frame(height: 1)
                    }
                    .padding(EdgeInsets(top: 64, leading: 32, bottom: 32, trailing: 32))
                    
                    VStack(alignment: .leading) {
                        Text("생년월일 6자리")
                            .font(.semiBoldHeadline)
                            .foregroundColor(.gray9)
                        TextField(String("예) 980123"), text: $bday)
                            .keyboardCleaned(keyboardType: .numberPad, text: $bday, wordCount: 6)
                            .focused($focusedField, equals: .bday)
                            .font(.lightCaption1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle()
                            .foregroundColor(.gray1)
                            .frame(height: 1)
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 32, trailing: 32))
                    
                    VStack(alignment: .leading) {
                        Text("성별")
                            .font(.semiBoldHeadline)
                            .foregroundColor(.gray9)
                            .padding(.bottom, 5)
                        HStack(spacing: 0) {
                            VStack(spacing: 5) {
                                Text("남성")
                                    .font(.lightHeadline)
                                    .foregroundColor(genderSelected == .male ? .gray9 : .gray2)
                                Rectangle()
                                    .foregroundColor(genderSelected == .male ? .gray9 : .gray1)
                                    .frame(height: 1)
                            }
                            .onTapGesture {
                                genderSelected = .male
                            }
                            
                            VStack(spacing: 5) {
                                Text("여성")
                                    .font(.lightHeadline)
                                    .foregroundColor(genderSelected == .female ? .gray9 : .gray2)
                                Rectangle()
                                    .foregroundColor(genderSelected == .female ? .gray9 : .gray1)
                                    .frame(height: 1)
                            }
                            .onTapGesture {
                                genderSelected = .female
                            }
                            
                            VStack(spacing: 5) {
                                Text("기타")
                                    .font(.lightHeadline)
                                    .foregroundColor(genderSelected == .others ? .gray9 : .gray2)
                                Rectangle()
                                    .foregroundColor(genderSelected == .others ? .gray9 : .gray1)
                                    .frame(height: 1)
                            }
                            .onTapGesture {
                                genderSelected = .others
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 64, trailing: 32))
                    
                    VStack {
                        HStack {
                            Button {
                                usageAgreementChecked.toggle()
                            } label: {
                                Image(usageAgreementChecked ? "checkbox-checked" : "checkbox")
                            }
                
                            Link(destination: URL(string: "https://polyester-ghoul-e62.notion.site/Unlock-b6ed1f758c0f41608f7a37ec8c6ce23f")!, label: {
                                Text("이용약관 동의")
                                    .underline()
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Button {
                                privacyChecked.toggle()
                            } label: {
                                Image(privacyChecked ? "checkbox-checked" : "checkbox")
                            }

                            Link(destination: URL(string: "https://www.unlock.im/privacy.html")!, label: {
                                Text("개인정보처리방침 동의")
                                    .underline()
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Button {
                                communityGuidelineChecked.toggle()
                            } label: {
                                Image(communityGuidelineChecked ? "checkbox-checked" : "checkbox")
                            }

                            Link(destination: URL(string: "https://polyester-ghoul-e62.notion.site/Unlock-23ca9a66c9ec429ca4ccea2fb593a417")!, label: {
                                Text("커뮤니티 이용규칙")
                                    .underline()
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .font(.lightCaption2)
                    .foregroundColor(.gray7)
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 32, trailing: 32))
                    
                    Button {
                        viewModel.postRegister(fullName: name, bDay: bday, gender: genderSelected?.rawValue ?? "others")
                    } label: {
                        if appState.isLoading {
                            ColoredProgressView(color: .gray)
                        } else {
                            Text("입장하기")
                                .font(.regularHeadline)
                                .foregroundColor(
                                    checkAllInput() ? .gray8 : .gray2
                                )
                                .padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray2)
                    }
                    .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 32))
                    .disabled(!checkAllInput())
                }
            }
            .navigationDestination(isPresented: $viewModel.registerSuccess, destination: {
                MainTabView()
            })
            
            if let errorMessage = appState.errorMessage {
                ErrorPopupView(errorText: errorMessage)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(image: $inputImage)
        })
        .onChange(of: inputImage, perform: { _ in
            loadImage()
            viewModel.postImage(file: (inputImage?.jpegData(compressionQuality: 0.8))!)
        })
        .onSubmit {
            focusedField = focusedField == .name ? .bday : nil
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func checkAllInput() -> Bool {
        guard name.count > 0 && bday.count > 0 else { return false }
        
        guard genderSelected != nil else { return false }
        
        guard usageAgreementChecked && privacyChecked && communityGuidelineChecked else { return false }
        
        return true
    }
}

struct ProfileInputView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInputView()
            .environmentObject(SignInViewModel())
            .environmentObject(AppState.shared)
    }
}
