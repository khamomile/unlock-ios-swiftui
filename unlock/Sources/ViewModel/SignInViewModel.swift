//
//  SignInViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/27.
//

import Foundation
import Alamofire
import Combine
import Moya

class SignInViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var subscription = Set<AnyCancellable>()

    private let appState = AppState.shared
    
    // CHECK EMAIL STATUS
    @Published var sentEmail: Bool = false
    @Published var emailVerified: Bool = false
    
    // CHECK USERNAME/PASSWORD STATUS
    @Published var usernameVerified: Bool = false
    @Published var passwordVerified: Bool = false
    
    // CHECK REGISTER STATUS
    @Published var finishedUploadingImage: Bool = false
    @Published var registerSuccess: Bool = false
    
    // VARIABLES FOR REGISTER
    var email: String = ""
    var emailAuthCode: String = ""
    var username: String = ""
    var password: String = ""
    var profileImageURL: String = ""
    
    func postSendEmailCode(email: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.postSendEmailCode(email: email))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post send email code failed: " + error.localizedDescription)
                case .finished:
                    print("Post send email code finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                self.email = email
                self.sentEmail = true
            }
            .store(in: &subscription)
    }
    
    func postCheckEmailCode(email: String, code: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.postCheckEmailCode(email: email, code: code))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post check email code failed: " + error.localizedDescription)
                case .finished:
                    print("Post check email code finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(SuccessResponse.self) else { return }
                print(responseData)
                if !responseData.success { self.appState.forceErrorMessage("인증번호가 일치하지 않아요.") }
                self.emailAuthCode = responseData.success ? code : ""
                self.emailVerified = responseData.success
            }
            .store(in: &subscription)
    }
    
    func postCheckUsernameDuplicate(username: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.postCheckUsernameDuplicate(username: username))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post check username duplicate failed: " + error.localizedDescription)
                case .finished:
                    print("Post check username duplicate finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(isDuplicateResponse.self) else { return }
                print(responseData)
                if responseData.isDuplicate { self.appState.forceErrorMessage("이미 사용 중인 아이디에요.\n다른 아이디를 입력해주세요.") }
                self.usernameVerified = !responseData.isDuplicate
                self.username = responseData.isDuplicate ? "" : username
            }
            .store(in: &subscription)
    }
    
    func setPW(password: String) {
        self.password = password
        self.passwordVerified = true
    }
    
    func postImage(file: Data) {
        provider.requestPublisher(.postProfileImage(file: file))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post image failed: " + error.localizedDescription)
                case .finished:
                    print("Post image finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CustomImage.self) else { return }
                print(responseData)
                self.profileImageURL = responseData.transforms[0].location
            }
            .store(in: &subscription)
    }
    
    func postRegister(fullName: String, bDay: String, gender: String) {
        let birthDate = Date.parseYMDDate(from: bDay) ?? Date()
        
        appState.isLoading = true
        
        provider.requestPublisher(.postRegister(username: username, password: password, email: email, fullname: fullName, birthDate: birthDate, gender: gender, profileImage: profileImageURL, emailAuthCode: emailAuthCode))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post register user failed: " + error.localizedDescription)
                case .finished:
                    print("Post register user finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(LoginResponse.self) else { return }
                print(responseData)
                self.registerSuccess = responseData.success
            }
            .store(in: &subscription)
    }
    
    func postLogin(email: String, password: String) {
        appState.isLoading = true
        
        provider.requestPublisher(.login(email: email, password: password))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post login failed: " + error.localizedDescription)
                case .finished:
                    print("Post login finished")
                }
            } receiveValue: { response in
                guard self.appState.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(LoginResponse.self) else { return }
                print(responseData)
                self.appState.getMe()
                self.appState.registerFcmToken()
                self.appState.loggedIn = true
            }
            .store(in: &subscription)
    }
    
    func postLogout() {
        provider.requestPublisher(.logout)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post logout failed: " + error.localizedDescription)
                case .finished:
                    print("Post logout finished")
                }
            } receiveValue: { response in
                print(response)
                guard let responseData = try? response.map(SuccessResponse.self) else { return }
                print(responseData)
                self.appState.loggedIn = false
            }
            .store(in: &subscription)
    }
}
