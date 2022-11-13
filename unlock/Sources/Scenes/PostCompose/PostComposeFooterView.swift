//
//  PostComposeFooterView.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/13.
//

import SwiftUI
import Kingfisher

struct PostComposeFooterView: View {
    @EnvironmentObject var unlockService: UnlockService
    @EnvironmentObject var viewModel: PostComposeViewModel
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker: Bool = false
    
    @Binding var postPublicStatus: PostPublicStatus
    
    var body: some View {
        HStack(spacing: 11) {
            Button {
                showingImagePicker = true
            } label: {
                Image("camera-black")
            }
            
            getComposerImageView()
            
            Spacer()
            
            Text("공개범위")
                .font(.mediumCaption1)
                .foregroundColor(.gray4)
            
            Button {
                postPublicStatus = .isPublic
            } label: {
                Text("전체")
                    .font(.boldBody)
                    .foregroundColor(postPublicStatus == .isPublic ? .gray9 : .gray6)
            }
            
            Button {
                postPublicStatus = .isNotPublic
            } label: {
                Text("친구")
                    .font(.boldBody)
                    .foregroundColor(postPublicStatus == .isNotPublic ? .gray9 : .gray6)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16))
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
    
    @ViewBuilder
    func getComposerImageView() -> some View {
        if viewModel.isPostingImage {
            ColoredProgressView(color: .gray)
                .frame(width: 24, height: 24)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray2)
                })
        } else if viewModel.images.count > 0 {
            KFImage(URL(string: viewModel.images.first?.url ?? ""))
                .placeholder {
                    Color.gray1
                }
                .retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .frame(width: 24, height: 24)
                .clipShape(Circle())
                .onTapGesture {
                    unlockService.doublePopupToShow = .deleteImageFromPost(leftAction: nil, rightAction: { viewModel.images = [] })
                    
                    withAnimation {
                        unlockService.showPopup = true
                    }
                }
        }
    }
}

struct PostComposeFooterView_Previews: PreviewProvider {
    static var previews: some View {
        PostComposeFooterView(postPublicStatus: .constant(.isPublic))
            .environmentObject(UnlockService.shared)
            .environmentObject(PostComposeViewModel())
    }
}
