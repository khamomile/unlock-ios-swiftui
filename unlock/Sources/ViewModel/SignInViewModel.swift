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

    private let unlockService = UnlockService.shared
    
    // CHECK LOGIN STATUS
    @Published var loggedIn: Bool = false
    @Published var notLoggedIn: Bool = false
    
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
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getUserLoggedIn()
        }
    }
    
    func postSendEmailCode(email: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.email = email
                self.sentEmail = true
            }
            .store(in: &subscription)
    }
    
    func postCheckEmailCode(email: String, code: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(SuccessResponse.self) else { return }
                print(responseData)
                if !responseData.success { self.unlockService.forceErrorMessage("인증번호가 일치하지 않아요.") }
                self.emailAuthCode = responseData.success ? code : ""
                self.emailVerified = responseData.success
            }
            .store(in: &subscription)
    }
    
    func postCheckUsernameDuplicate(username: String) {
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(isDuplicateResponse.self) else { return }
                print(responseData)
                if responseData.isDuplicate { self.unlockService.forceErrorMessage("이미 사용 중인 아이디에요.\n다른 아이디를 입력해주세요.") }
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(CustomImage.self) else { return }
                print(responseData)
                self.profileImageURL = responseData.transforms[0].location
            }
            .store(in: &subscription)
    }
    
    func postRegister(fullName: String, bDay: String, gender: String) {
        let birthDate = Date.parseYMDDate(from: bDay) ?? Date()
        
        unlockService.isLoading = true
        
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
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(LoginResponse.self) else { return }
                print(responseData)
                self.registerSuccess = responseData.success
            }
            .store(in: &subscription)
    }

    // CHECKING STATUS
    func getUserLoggedIn() {
        provider.requestPublisher(.userLoggedIn)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get user logged in failed: " + error.localizedDescription)
                case .finished:
                    print("Get user logged in finished")
                }
            } receiveValue: { response in
                guard let responseData = try? response.map(Bool.self) else { return }
                print(responseData)
                self.loggedIn = responseData
                self.notLoggedIn = !responseData
            }
            .store(in: &subscription)
    }
    
    func postLogin(email: String, password: String) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.login(email: email, password: password))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post login failed: " + error.localizedDescription)
                case .finished:
                    print("Post login finished")
                }
            } receiveValue: { response in
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(LoginResponse.self) else { return }
                print(responseData)
                self.unlockService.getMe()
                self.unlockService.registerFcmToken()
                self.loggedIn = true
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
                self.loggedIn = false
            }
            .store(in: &subscription)

    }
//    func logIn(email: String, password: String) {
//        UnlockService.shared.postLogin(email: email, password: password)
//    }
}
