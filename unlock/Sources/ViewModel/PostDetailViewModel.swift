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
    
    private let unlockService = UnlockService.shared
    
    @Published var post: Post?
    @Published var comments: [Comment] = []
    
    @Published var deleteSuccess: Bool = false
    @Published var reportSuccess: Bool = false
    
    @Published var moveToReportView: Bool = false
    @Published var moveToEditView: Bool = false
    
    @Published var newCommentAdded: Bool = false
    
    // VIEWMODELS FOR UPDATE
    var homeFeedViewModel: HomeFeedViewModel?
    var discoverFeedViewModel: DiscoverFeedViewModel?
    var profileViewModel: ProfileViewModel?
    
    func getPost(id: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PostResponse.self) else { return }
                print(responseData)
                self.post = Post(data: responseData)
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
    
    func getComment(id: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
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
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CountResponse.self) else { return }
                print(responseData)
                self.getPost(id: post.id)
            }
            .store(in: &subscription)
    }
    
    // DISLIKE POST
    func patchDislike(id: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CountResponse.self) else { return }
                print(responseData)
                self.getPost(id: post.id)
            }
            .store(in: &subscription)
    }
    
    // DELETE POST
    func deletePost(id: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PostResponse.self) else { return }
                print(responseData)
                self.bridgeDeletedPost()
                self.deleteSuccess = true
            }
            .store(in: &subscription)
    }
    
    // HIDE POST
    func hidePost(id: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.post?.didHide = true
                self.post?.showTrace = true
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
    
    func unhidePost(id: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.post?.didHide = false
                self.post?.showTrace = false
                self.updatePostListInfo()
            }
            .store(in: &subscription)
    }
    
    // report post
    func reportPost(type: String, postId: String, reason: Int, content: String) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.postReport(type: type, postId: postId, commentId: nil, reason: reason, content: content))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Report post failed: " + error.localizedDescription)
                case .finished:
                    print("Report post finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(ReportResponse.self) else { return }
                print(responseData)
                self.reportSuccess = true
            }
            .store(in: &subscription)
    }
    
    func reportComment(type: String, commentId: String, reason: Int, content: String) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.postReport(type: type, postId: nil, commentId: commentId, reason: reason, content: content))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Report comment failed: " + error.localizedDescription)
                case .finished:
                    print("Report comment finished")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(ReportResponse.self) else { return }
                print(responseData)
                self.reportSuccess = true
            }
            .store(in: &subscription)
    }
    
    // post comment
    func postComment(postId: String, content: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CommentResponse.self) else { return }
                print(responseData)
                self.getComment(id: postId)
                self.newCommentAdded.toggle()
            }
            .store(in: &subscription)
    }
    
    func postBlock(userId: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.bridgeBlockedUser(blockedUserId: userId)
            }
            .store(in: &subscription)
    }
}
