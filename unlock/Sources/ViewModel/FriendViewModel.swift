//
//  FriendViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/04.
//

import Foundation
import Alamofire
import Combine
import Moya

class FriendViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var subscription = Set<AnyCancellable>()
    
    private let unlockService = UnlockService.shared
    
    // FOR SEARCH
    @Published var userList: [User] = []
    @Published var userStatusList: [User: (FriendStatus, Bool)] = [:]
    @Published var friendStatusList: [Friend] = []
    
    // FOR PROFILE FRIEND LIST
    @Published var friendList: [User] = []
    @Published var friendRequestList: [User] = []
    
    // VIEWMODELS FOR UPDATE
    var homeFeedViewModel: HomeFeedViewModel?
    var discoverFeedViewModel: DiscoverFeedViewModel?
    var profileViewModel: ProfileViewModel?
    
    func getUserList(keyword: String) {
        provider.requestPublisher(.getUserList(keyword: keyword))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get user list failed: " + error.localizedDescription)
                case .finished:
                    print("Get user list finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map([UserResponse].self) else { return }
                print(responseData)
                
                self.userList = responseData.compactMap {
                    if self.unlockService.me.id != $0._id {
                        return User(data: $0)
                    }
                    return nil
                }
                
                for user in self.userList {
                    if self.userStatusList[user] == nil {
                        self.userStatusList[user] = (.noRelationship, false)
                    }
                }
                
                self.getFriendMutualRequests()
            }
            .store(in: &subscription)
    }
    
    func getFriendMutualRequests() {
        provider.requestPublisher(.getFriendMutualRequestList)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get friend mutual requests failed: " + error.localizedDescription)
                case .finished:
                    print("Get friend mutual requests finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map([FriendResponse].self) else { return }
                print(responseData)
                self.friendStatusList = responseData.map {
                    Friend(data: $0)
                }
                self.updateUserStatusList()
            }
            .store(in: &subscription)
    }
    
    func deleteFriend(id: String) {
        provider.requestPublisher(.deleteFriend(id: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Delete friend failed: " + error.localizedDescription)
                case .finished:
                    print("Delete friend finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.unlockService.getMe()
                self.getFriendMutualRequests()
                self.getFriendList()
            }
            .store(in: &subscription)
    }
    
    func patchFriend(id: String) {
        provider.requestPublisher(.patchFriend(id: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Patch friend failed: " + error.localizedDescription)
                case .finished:
                    print("Patch friend finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.unlockService.getMe()
                self.getFriendMutualRequests()
                self.getFriendList()
            }
            .store(in: &subscription)
    }
    
    func postRequestFriend(id: String) {
        provider.requestPublisher(.postRequestFriend(id: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post request friend failed: " + error.localizedDescription)
                case .finished:
                    print("Post request friend finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.unlockService.getMe()
                self.getFriendMutualRequests()
            }
            .store(in: &subscription)
    }
    
    func getFriendList() {
        unlockService.isLoading = true
        
        provider.requestPublisher(.getMyFriendList)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get my friend list failed: " + error.localizedDescription)
                case .finished:
                    print("Get my friend list finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map([FriendResponse].self) else { return }
                print(responseData)
                
                self.friendList = responseData.compactMap {
                    if self.unlockService.me.id != $0.requester._id {
                        return User(data: $0.requester)
                    }
                    
                    if self.unlockService.me.id != $0.recipient._id {
                        return User(data: $0.recipient)
                    }
                    
                    return nil
                }
                self.getFriendRequestList()
                
                self.unlockService.isLoading = false
            }
            .store(in: &subscription)
    }
    
    func getFriendRequestList() {
        unlockService.isLoading = true
        
        provider.requestPublisher(.getFriendRequestList)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get friend request list failed: " + error.localizedDescription)
                case .finished:
                    print("Get friend request list finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map([FriendRequestResponse].self) else { return }
                print(responseData)
                
                self.friendRequestList = responseData.map {
                    return User(data: $0.requester)
                }
                
                self.unlockService.isLoading = false
            }
            .store(in: &subscription)
    }
}

// HELPER FUNCTION
extension FriendViewModel {
    func findFriendStatus(id: String) -> (FriendStatus, Bool) {
        if let friendStatus = friendStatusList.first(where: { $0.requester.id == id }) {
            return (friendStatus.status, true)
        } else if let friendStatus = friendStatusList.first(where: { $0.recipient.id == id }) {
            return (friendStatus.status, false)
        }
        
        return (.noRelationship, false)
    }
    
    func updateUserStatusList() {
        for user in userList {
            userStatusList[user] = findFriendStatus(id: user.id)
        }
    }
}
