//
//  DiscoverFeedViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/04.
//

import Foundation
import Alamofire
import Combine
import Moya

class DiscoverFeedViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    private var subscription = Set<AnyCancellable>()

    private let unlockService = UnlockService.shared
    
    @Published var pageNo: Int = 1
    @Published var totalPageNo: Int = 1
    
    @Published var postList: [Post] = []
    @Published var tempPostList: [Post] = []
    
    @Published var newPageUpdated: Bool = false
    
    init() {
        getPage()
        getNextPages(nextPageNo: pageNo + 1)
        
//        $tempPostList
//            .filter { $0.count == 0}
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                self.getNextPages(nextPageNo: self.pageNo)
//            }
//            .store(in: &subscription)
    }
    
    func getPage() {
        provider.requestPublisher(.getDiscover(page: pageNo))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get page failed: " + error.localizedDescription)
                case .finished:
                    print("Get page finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PaginatedResultResponse.self) else { return }
                // print(responseData)
                self.totalPageNo = responseData.totalPages
                print("Total page: \(self.totalPageNo)")
                self.postList = responseData.docs.map {
                    Post(data: $0)
                }
            }
            .store(in: &subscription)
    }
    
//    func updateNextPages() {
//        for post in tempPostList {
//            postList.append(post)
//            print("Appended post: \(post.title)")
//        }
//
//        tempPostList = []
//    }
    
    func getNextPages(nextPageNo: Int) {
        newPageUpdated = false
        // print("Page no: \(nextPageNo)", "tempPostList count: \(tempPostList.count)")
        
        
        provider.requestPublisher(.getDiscover(page: nextPageNo))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get next page failed: " + error.localizedDescription)
                case .finished:
                    print("Get next page finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PaginatedResultResponse.self) else { return }
                // print(responseData)
                
                for post in self.tempPostList {
                    self.postList.append(post)
                    // print("Page no: \(nextPageNo)", "Appended post: \(post.title)")
                }

                self.tempPostList = []
                
                self.tempPostList = responseData.docs.map {
                    Post(data: $0)
                }
                print("Fetched Page: \(nextPageNo)")
                
                self.pageNo = nextPageNo == 2 ? self.pageNo + 2 : self.pageNo + 1
                // print("Page no: \(nextPageNo)", "New page no: \(self.pageNo)")
                self.newPageUpdated = true
            }
            .store(in: &subscription)
    }
    
    func refreshPages() {
        postList = []
        tempPostList = []
        pageNo = 1
        totalPageNo = 1
        
        getPage()
        getNextPages(nextPageNo: pageNo + 1)
    }
}
