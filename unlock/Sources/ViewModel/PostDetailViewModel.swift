//
//  PostDetailViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/02.
//

import Foundation
import Alamofire
import Combine
import Moya

class PostDetailViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var subscription = Set<AnyCancellable>()
    
    private let appState = AppState.shared
    
    @Published var post: Post?
    @Published var comments: [Comment] = []

    // 0. VIEWMODELS FOR UPDATE
    var homeFeedViewModel: HomeFeedViewModel?
    var discoverFeedViewModel: DiscoverFeedViewModel?
    var profileViewModel: ProfileViewModel?

    // 1. STATUS
    // 1.0 CRUD
    @Published var moveToEditView: Bool = false
    @Published var deleteSuccess: Bool = false
    @Published var newCommentAdded: Bool = false
    // 1.1 REPORT
    @Published var moveToReportPostView: Bool = false
    @Published var moveToReportCommentView: Bool = false
    @Published var reportSuccess: Bool = false

    // 2. REPORT DATA
    @Published var reportCommentId: String = ""
    
    func getPost(id: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.getPost(id: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get post failed: " + error.localizedDescription)
                case .finished:
                    print("Get post finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PostResponse.self) else { return }
                print(responseData)
                self.post = Post(data: responseData)
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
    
    func getComment(id: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.getComment(postId: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get comment failed: " + error.localizedDescription)
                case .finished:
                    print("Get comment finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map([CommentResponse].self) else { return }
                print(responseData)
                self.comments = responseData.map {
                    Comment(data: $0)
                }
                self.getPost(id: self.post?.id ?? "")
            }
            .store(in: &subscription)
    }
    
    // LIKE POST
    func patchLike(id: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.patchLike(id: id, mode: "add-like"))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Patch like failed: " + error.localizedDescription)
                case .finished:
                    print("Patch like finished")
                }
            } receiveValue: { response in
                guard let post = self.post else { return }
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CountResponse.self) else { return }
                print(responseData)
                self.getPost(id: post.id)
            }
            .store(in: &subscription)
    }
    
    // DISLIKE POST
    func patchDislike(id: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.patchDislike(id: id, mode: "remove-like"))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Patch dislike failed: " + error.localizedDescription)
                case .finished:
                    print("Patch dislike finished")
                }
            } receiveValue: { response in
                guard let post = self.post else { return }
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CountResponse.self) else { return }
                print(responseData)
                self.getPost(id: post.id)
            }
            .store(in: &subscription)
    }
    
    // DELETE POST
    func deletePost(id: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.deletePost(id: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Delete post failed: " + error.localizedDescription)
                case .finished:
                    print("Delete post finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PostResponse.self) else { return }
                print(responseData)
                self.bridgeDeletedPost()
                self.deleteSuccess = true
            }
            .store(in: &subscription)
    }
    
    // HIDE POST
    func hidePost(id: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.hidePost(id: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Hide post failed: " + error.localizedDescription)
                case .finished:
                    print("Hide post finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                self.post?.didHide = true
                self.post?.showTrace = true
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
    
    func unhidePost(id: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.unhidePost(id: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Unhide post failed: " + error.localizedDescription)
                case .finished:
                    print("Unhide post finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                self.post?.didHide = false
                self.post?.showTrace = false
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
    
    // post comment
    func postComment(postId: String, content: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.postComment(postId: postId, content: content))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post comment failed: " + error.localizedDescription)
                case .finished:
                    print("Post comment finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CommentResponse.self) else { return }
                print(responseData)
                self.getComment(id: postId)
                self.newCommentAdded.toggle()
            }
            .store(in: &subscription)
    }
    
    func postBlock(userId: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.postBlock(userId: userId))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post block failed: " + error.localizedDescription)
                case .finished:
                    print("Post block finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                self.bridgeBlockedUser(blockedUserId: userId)
            }
            .store(in: &subscription)
    }
}
