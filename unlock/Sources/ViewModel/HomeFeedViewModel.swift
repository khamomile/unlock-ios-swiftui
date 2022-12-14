//
//  HomeFeedViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/04.
//

import Foundation
import Alamofire
import Combine
import Moya
import SwiftUI

class HomeFeedViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    private var subscription = Set<AnyCancellable>()
    
    private let appState = AppState.shared
    
    // PAGING INFORMATION
    @Published var pageNo: Int = 1
    @Published var totalPageNo: Int = 1
    @Published var newPageUpdated: Bool = false
    
    // POST STORING
    @Published var postList: [Post] = []
    @Published var tempPostList: [Post] = []
    
    // LOADING STATUS
    @Published var isLoadingPost: Bool = false
    
    var updatedLikesCount: [String : Int] = [:]
    var updatedDidLike: [String : Bool] = [:]
    
    var postPagingCalled: [Int : Bool] = [:]
    
    init() {
        getPage()
        getNextPages(nextPageNo: pageNo + 1)
    }
    
    func getPage() {
        isLoadingPost = true
        
        provider.requestPublisher(.getFeed(page: pageNo))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get page failed: " + error.localizedDescription)
                case .finished:
                    print("Get page finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PaginatedResultResponse.self) else { return }
                self.totalPageNo = responseData.totalPages
                self.postList = responseData.docs.map {
                    Post(data: $0)
                }
                self.isLoadingPost = false
            }
            .store(in: &subscription)
    }
    
    func getNextPages(nextPageNo: Int) {
        newPageUpdated = false
        
        print("Index: Get Next Page Called")
        
        provider.requestPublisher(.getFeed(page: nextPageNo))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get next page failed: " + error.localizedDescription)
                case .finished:
                    print("Get next page finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(PaginatedResultResponse.self) else { return }
                
                self.postList.append(contentsOf: self.tempPostList)
                
                self.tempPostList = []
                
                self.tempPostList = responseData.docs.map {
                    Post(data: $0)
                }
                print("Fetched Page: \(nextPageNo)")
                
                self.pageNo = nextPageNo == 2 ? self.pageNo + 2 : self.pageNo + 1
                self.newPageUpdated = true
            }
            .store(in: &subscription)
    }
    
    func lastUnhiddenPostIndex() -> Int {
        let idx = postList.lastIndex(where: { ($0.didHide == false && $0.didBlock == false) || $0.showTrace == true })
        
        return idx ?? 0
    }
    
    func refreshPages() {
        postList = []
        tempPostList = []
        postPagingCalled = [:]
        pageNo = 1
        totalPageNo = 1
        
        getPage()
        getNextPages(nextPageNo: pageNo + 1)
    }
}
