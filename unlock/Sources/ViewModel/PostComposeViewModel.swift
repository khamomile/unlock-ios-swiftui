//
//  PostComposeViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/07.
//

import Foundation
import Alamofire
import Combine
import Moya

class PostComposeViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var subscription = Set<AnyCancellable>()
    
    private let unlockService = UnlockService.shared
    
    // VIEWMODELS FOR UPDATE
    var homeFeedViewModel: HomeFeedViewModel?
    var discoverFeedViewModel: DiscoverFeedViewModel?
    var profileViewModel: ProfileViewModel?
    
    // CREATE & EDIT STATUS
    @Published var postSuccess: Bool = false
    @Published var editSuccess: Bool = false
    
    // CREATED POST'S ID
    @Published var postId: String = ""
    
    @Published var postToEdit: Post?
    @Published var postToEditId: String?
    
    @Published var images: [PostImage] = []
    @Published var isPostingImage: Bool = false
    
    func postPost(title: String, content: String, showPublic: Bool, images: [PostImage]) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.postPost(title: title, content: content, htmlContent: content.toHTMLContent(), showPublic: showPublic, images: images))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post post failed: " + error.localizedDescription)
                case .finished:
                    print("Post post finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PostResponse.self) else { return }
                self.postId = responseData._id
                self.postSuccess = true
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
    
    func putPost(id: String, title: String, content: String, showPublic: Bool, images: [PostImage]) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.putPost(id: id, title: title, content: content, htmlContent: content.toHTMLContent(), showPublic: showPublic, images: images))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Put post failed: " + error.localizedDescription)
                case .finished:
                    print("Put post finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PostResponse.self) else { return }
                self.postId = responseData._id
                self.postSuccess = true
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
    
    func postImage(file: Data) {
        isPostingImage = true
        
        provider.requestPublisher(.postPostImage(file: file))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post image failed: " + error.localizedDescription)
                case .finished:
                    print("Post image finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CustomImage.self) else { return }
                print(responseData)
                self.images = [PostImage(url: responseData.transforms[0].location, image: responseData._id)]
                self.isPostingImage = false
            }
            .store(in: &subscription)
    }
    
    func getPost() {
        unlockService.isLoading = true
        
        provider.requestPublisher(.getPost(id: postToEditId ?? ""))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get post failed: " + error.localizedDescription)
                case .finished:
                    print("Get post finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PostResponse.self) else { return }
                print(responseData)
                self.postToEdit = Post(data: responseData)
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
}

extension PostComposeViewModel {
    // SETTING UP VIEWMODEL
    func setViewModel(homeFeedViewModel: HomeFeedViewModel, discoverFeedViewModel: DiscoverFeedViewModel, profileViewModel: ProfileViewModel) {
        self.homeFeedViewModel = homeFeedViewModel
        self.discoverFeedViewModel = discoverFeedViewModel
        self.profileViewModel = profileViewModel
    }
    
    func updatePostListInfo() {
        guard postId.count > 0 else { return }
        
        guard let homeFeedViewModel = homeFeedViewModel, let discoverFeedViewModel = discoverFeedViewModel, let profileViewModel = profileViewModel else { return }
        
        homeFeedViewModel.refreshPages()
        discoverFeedViewModel.refreshPages()
        profileViewModel.getMyPosts()
    }
}
