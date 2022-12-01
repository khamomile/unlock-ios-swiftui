//
//  AppState.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/27.
//

import Foundation
import Alamofire
import Combine
import Moya
import SwiftUI

enum ResponseHandledResult {
    case success
    case failed
}

class AppState: ObservableObject {
    static let shared = AppState()
    
    private init() { }
    
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()))
    private var subscription = Set<AnyCancellable>()
    
    // GENERAL STATUS
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    @Published var showPopup: Bool = false
    @Published var doublePopupToShow: DoublePopupInfo?
    
    // IMAGE POPUP
    @Published var showImageView: Bool = false
    @Published var postToShowImage: Post?
    
    // GET USER
    @Published var me: User = User()
    
    // PUSH-NOTIFICATION
    @Published var notiReceived: Bool = false
    @Published var notiDestination: PushNotiType?
}

extension AppState {
    func handleResponse(_ response: Response) -> ResponseHandledResult {
        
#if DEBUG
        print(response)
        print(response.statusCode)
        print(String(data: response.data, encoding: .utf8)!)
#endif
        
        if (200..<300) ~= response.statusCode {
            isLoading = false
            return .success
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            if response.statusCode == 401 {
                errorMessage = UnlockError.unauthorized.message
            } else if response.statusCode == 403 {
                errorMessage = UnlockError.forbidden.message
            } else if response.statusCode == 404 {
                errorMessage = UnlockError.network.message
            } else if response.statusCode == 500 {
                errorMessage = UnlockError.serverError.message
            } else {
                if let errorResponse = try? response.map(ErrorResponse.self) {
                    errorMessage = errorResponse.message
                } else if let errorType = try? response.map(ErrorType.self) {
                    errorMessage = errorType.message
                } else {
                    errorMessage = UnlockError.unknown.message
                }
            }
        }
        
        isLoading = false
        
        return .failed
    }
    
    func forceErrorMessage(_ message: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.errorMessage = message
        }
    }

    func setDoublePopup(_ doublePopup: DoublePopupInfo?) {
        if let doublePopup = doublePopup {
            self.doublePopupToShow = doublePopup

            withAnimation {
                showPopup = true
            }
        }
    }
    
    func getMe() {
        provider.requestPublisher(.getMe)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get me failed: " + error.localizedDescription)
                case .finished:
                    print("Get me finished")
                }
            } receiveValue: { response in
                guard self.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(UserResponse.self) else { return }
                print(responseData)
                self.me = User(data: responseData)
            }
            .store(in: &subscription)
    }
    
    func registerFcmToken() {
        guard let token = UserDefaults.standard.string(forKey: "fcmToken") else { return }
        
        provider.requestPublisher(.registerFcmToken(token: token))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Register fcm token failed: " + error.localizedDescription)
                case .finished:
                    print("Register fcm token finished")
                }
            } receiveValue: { response in
                guard self.handleResponse(response) == .success else { return }
                print("Sent fcm token to server")
            }
            .store(in: &subscription)
    }
    
    func removeFcmToken() {
        provider.requestPublisher(.registerFcmToken(token: ""))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Register fcm token failed: " + error.localizedDescription)
                case .finished:
                    print("Register fcm token finished")
                }
            } receiveValue: { response in
                guard self.handleResponse(response) == .success else { return }
            }
            .store(in: &subscription)
    }
}
