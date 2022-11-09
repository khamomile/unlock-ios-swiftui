//
//  PostComposeView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI
import Kingfisher

struct PostComposeView: View {
    @EnvironmentObject var unlockService: UnlockService
    @StateObject var viewModel: PostComposeViewModel = PostComposeViewModel()
    
    @EnvironmentObject var homeFeedViewModel: HomeFeedViewModel
    @EnvironmentObject var discoverFeedViewModel: DiscoverFeedViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var titleText: String = ""
    @State private var contentText: String = ""
    @State private var postPublicStatus: PostPublicStatus = .isPublic
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker: Bool = false
    
    @Binding var path: NavigationPath
    
    var postToEditId: String?
    
    var body: some View {
        VStack {
            PostHeaderView(titleText: $titleText, contentText: $contentText, showPublic: $postPublicStatus)
                .environmentObject(viewModel)
            
            ScrollView {
                TextField("제목을 입력하세요", text: $titleText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(.boldBody)
                    .foregroundColor(.gray9)
                    .padding(EdgeInsets(top: 10, leading: 16, bottom: 5, trailing: 16))
                
                Divider()
                    .padding(.horizontal, 16)
                
                TextEditorApproachView(text: $contentText, placeholder: "내용을 입력하세요.", editorBackgroundColor: .white)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            Divider()
                .padding(.horizontal, 16)
            
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
            
        }
        .navigationDestination(isPresented: $viewModel.postSuccess, destination: {
            if viewModel.postId.count > 0 {
                PostDetailView(path: $path, postID: viewModel.postId)
            }
        })
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            print("Post compose path: ", path.count)
            
            viewModel.setViewModel(homeFeedViewModel: homeFeedViewModel, discoverFeedViewModel: discoverFeedViewModel, profileViewModel: profileViewModel)
            
            if let postToEditId = postToEditId {
                viewModel.postToEditId = postToEditId
                viewModel.getPost()
            }
        }
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(image: $inputImage)
        })
        .onChange(of: inputImage, perform: { _ in
            loadImage()
            viewModel.postImage(file: (inputImage?.jpegData(compressionQuality: 0.8))!)
        })
        .onChange(of: viewModel.postToEdit) { post in
            titleText = post?.title ?? ""
            contentText = post?.swiftContent ?? ""
            postPublicStatus = (post?.showPublic ?? false) ? .isPublic : .isNotPublic
            viewModel.images = post?.images ?? []
        }
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
        }
    }
}

struct PostHeaderView: View {
    @EnvironmentObject var viewModel: PostComposeViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var titleText: String
    @Binding var contentText: String
    @Binding var showPublic: PostPublicStatus
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                dismiss()
            } label: {
                Image("angle-left")
            }
            
            Spacer()
            
            Text("글쓰기")
                .font(.lightBody)
                .foregroundColor(.gray9)
            
            Spacer()
            
            Button {
                if let postToEdit = viewModel.postToEdit {
                    viewModel.putPost(id: postToEdit.id, title: titleText, content: contentText, showPublic: showPublic.boolValue, images: viewModel.images)
                } else {
                    viewModel.postPost(title: titleText, content: contentText, showPublic: showPublic.boolValue, images: viewModel.images)
                }
            } label: {
                Text("완료")
                    .font(.boldBody)
                    .foregroundColor(contentsFilled() ? .gray9 : .gray1)
            }
            .disabled(!contentsFilled())
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        
        Divider()
    }
    
    func contentsFilled() -> Bool {
        return titleText.count > 0 && contentText.count > 0
    }
}

struct PostComposeView_Previews: PreviewProvider {
    static var previews: some View {
        PostComposeView(path: .constant(NavigationPath()))
            .environmentObject(UnlockService.shared)
            .environmentObject(HomeFeedViewModel())
            .environmentObject(DiscoverFeedViewModel())
            .environmentObject(ProfileViewModel())
    }
}
