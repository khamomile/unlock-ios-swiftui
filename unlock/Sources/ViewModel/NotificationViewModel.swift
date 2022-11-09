//
//  NotificationViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/09.
//

import Foundation
import Alamofire
import Combine
import Moya

class NotificationViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var subscription = Set<AnyCancellable>()
    
    private let unlockService = UnlockService.shared
    
    // NOTIFICATION
    @Published var notiList: [Notification] = []
    @Published var hasUnread: Bool = false
    
    // VIEWMODELS FOR UPDATE
    var homeFeedViewModel: HomeFeedViewModel?
    var discoverFeedViewModel: DiscoverFeedViewModel?
    var profileViewModel: ProfileViewModel?
    
    func getNotiList() {
        unlockService.isLoading = true
        
        provider.requestPublisher(.getNotificationList)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get notificaiton list failed: " + error.localizedDescription)
                case .finished:
                    print("Get notification list finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map([NotificationResponse].self) else { return }
                print(responseData)
                
                self.notiList = responseData.map {
                    Notification(data: $0)
                }
                
                self.readNoti()
            }
            .store(in: &subscription)
    }
    
    func readNoti() {
        provider.requestPublisher(.putReadAllNotifications)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Read notification failed: " + error.localizedDescription)
                case .finished:
                    print("Read notification finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.hasUnread = false
            }
            .store(in: &subscription)
    }
    
    func getUnreadNoti() {
        provider.requestPublisher(.getHasUnreadNotification)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get unread notification failed: " + error.localizedDescription)
                case .finished:
                    print("Get unread notification finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(Bool.self) else { return }
                self.hasUnread = responseData
                print("Has unread called")
            }
            .store(in: &subscription)
    }
}
