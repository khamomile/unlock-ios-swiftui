//
//  ProfileViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/02.
//

import Foundation
import Alamofire
import Combine
import Moya

class ProfileViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var subscription = Set<AnyCancellable>()
    
    private let unlockService = UnlockService.shared
    
    @Published var myPosts: [Post] = []
    
    var updatedLikesCount: [String : Int] = [:]
    
    init() {
        getMyPosts(isInitial: true)
    }
    
    func getMyPosts(isInitial: Bool = false) {
        if !isInitial {
            unlockService.isLoading = true
        }

        provider.requestPublisher(.getMyPosts)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get my posts failed: " + error.localizedDescription)
                case .finished:
                    print("Get my posts finished")
                }
            } receiveValue: { response in
                print(response)
                print("HERE1")
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map([PostResponse].self) else { return }
                print(responseData)
                print("HERE2")
                self.myPosts = responseData.map {
                    Post(data: $0)
                }
                print("Why?", self.myPosts.count)
            }
            .store(in: &subscription)
    }
}
