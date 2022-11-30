//
//  SettingViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/31.
//

import Foundation
import Alamofire
import Combine
import Moya

class SettingViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var subscription = Set<AnyCancellable>()
    
    private let unlockService = UnlockService.shared
    
    // 0. VIEWMODELS FOR UPDATE
    var homeFeedViewModel: HomeFeedViewModel?
    var discoverFeedViewModel: DiscoverFeedViewModel?
    var profileViewModel: ProfileViewModel?
    
    // 1. STATUS
    // 1.0 GENERAL
    @Published var moveToMain: Bool = false
    // 1.1 LOGOUT
    @Published var logoutSuccess: Bool = false
    // 1.2 PROFILE-EDIT
    @Published var usernameVerified: Bool = false
    @Published var isPostingImage: Bool = false
    @Published var editSuccess: Bool = false
    @Published var cancelEditAlert: Bool = false

    @Published var validResetEmail: Bool = false
    @Published var resetEmailSent: Bool = false
    @Published var emailVerified: Bool = false
    @Published var pwChanged: Bool = false
    
    @Published var userDeleted: Bool = false

    // 2. PROFILE-EDIT DATA
    @Published var eUsername: String = ""
    @Published var eName: String = ""
    @Published var eBDay: String = ""
    @Published var eBio: String = ""
    @Published var profileImageURL: String = ""

    var email: String = ""
    var code: String = ""
    
    // BLOCKED USER
    @Published var blockedUsers: [User] = []
    
    init() {
        setUpProfileEditData()

        $usernameVerified
            .filter { $0 == true }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.putUser(username: self.eUsername, fullname: self.eName, bDay: self.eBDay, profileImage: self.profileImageURL, bio: self.eBio)
            }
            .store(in: &subscription)
        
        $validResetEmail
            .filter { $0 == true }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.postSendResetPWEmailCode(email: self.email)
            }
            .store(in: &subscription)
        
        $pwChanged
            .filter { $0 == true }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.postLogout()
            }
            .store(in: &subscription)
        
        $userDeleted
            .filter { $0 == true }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.postLogout()
            }
            .store(in: &subscription)
    }

    func setUpProfileEditData() {
        eUsername = unlockService.me.username
        eName = unlockService.me.fullname
        eBDay = unlockService.me.birthDate.format(with: "yyMMdd")
        eBio = unlockService.me.bio
        profileImageURL = unlockService.me.profileImage
    }

    func profileChanged() -> Bool {
        let condition1 = profileImageURL != unlockService.me.profileImage
        let condition2 = eName != unlockService.me.fullname
        let condition3 = eUsername != unlockService.me.username
        let condition4 = eBDay != unlockService.me.birthDate.format(with: "yyMMdd")
        let condition5 = eBio != unlockService.me.bio

        return condition1 || condition2 || condition3 || condition4 || condition5
    }

    func postEdit() {
        if eUsername != unlockService.me.username {
            if Utils.inIDFormat(eUsername) {
                postCheckUsernameDuplicate(username: eUsername)
            } else {
                unlockService.forceErrorMessage("5글자 이상 20글자 이하의 아이디를 입력해주세요.")
            }
        } else {
            usernameVerified = true
        }
    }

    func showCancelEditAlert(_ show: Bool) {
        cancelEditAlert = show
    }

    func setMoveToMain(_ set: Bool) {
        moveToMain = set
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
                self.logoutSuccess = true
            }
            .store(in: &subscription)
    }
    
    func postImage(file: Data) {
        isPostingImage = true
        
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
                self.isPostingImage = false
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
            }
            .store(in: &subscription)
    }

    func putUser(username: String, fullname: String, bDay: String, profileImage: String, bio: String) {
        let birthDate = Date.parseYMDDate(from: bDay) ?? Date()
        
        unlockService.isLoading = true
        
        provider.requestPublisher(.putUser(id: unlockService.me.id, username: username, fullname: fullname, birthDate: birthDate, profileImage: profileImage, bio: bio))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Put user failed: " + error.localizedDescription)
                case .finished:
                    print("Put user finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(UserResponse.self) else { return }
                print(responseData)
                self.editSuccess = true
                self.usernameVerified = false
                self.unlockService.getMe()
            }
            .store(in: &subscription)
    }
    
    func postCheckEmailDuplicate(email: String) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.postCheckEmailDuplicate(email: email))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Post check email duplicate failed: " + error.localizedDescription)
                case .finished:
                    print("Post check email duplicate finished.")
                }
            } receiveValue: { response in
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(isDuplicateResponse.self) else { return }
                print(responseData)
                if !responseData.isDuplicate { self.unlockService.forceErrorMessage("가입되지 않은 이메일입니다.") }
                self.email = responseData.isDuplicate ? email : ""
                self.validResetEmail = responseData.isDuplicate
            }
            .store(in: &subscription)
    }
    
    func postSendResetPWEmailCode(email: String) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.postSendResetPWEmailCode(email: email))
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
                self.resetEmailSent = true
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
                self.code = responseData.success ? code : ""
                self.emailVerified = responseData.success
            }
            .store(in: &subscription)
    }
    
    func putResetPassword(email: String, code: String, newPW: String) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.putResetPassword(email: email, code: code, newPassword: newPW))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Put reset password failed: " + error.localizedDescription)
                case .finished:
                    print("Put reset password finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.pwChanged = true
            }
            .store(in: &subscription)
    }
    
    func deleteUser() {
        unlockService.isLoading = true
        
        provider.requestPublisher(.deleteUser)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Delete user failed: " + error.localizedDescription)
                case .finished:
                    print("Delete user finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map(SuccessResponse.self) else { return }
                self.userDeleted = responseData.success
            }
            .store(in: &subscription)
    }
    
    func getBlockedUserList() {
        unlockService.isLoading = true
        
        provider.requestPublisher(.getBlockedUsers)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Get blocked user list failed: " + error.localizedDescription)
                case .finished:
                    print("Get blocked user list finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let responseData = try? response.map([BlockedUserResponse].self) else { return }
                print(responseData)
                
                self.blockedUsers = responseData.map {
                    User(data: $0.target)
                }
                
                self.unlockService.isLoading = false
            }
            .store(in: &subscription)
    }
    
    func unblockUser(userId: String) {
        unlockService.isLoading = true
        
        provider.requestPublisher(.deleteBlock(userId: userId))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Unblock user failed: " + error.localizedDescription)
                case .finished:
                    print("Unblock user finished.")
                }
            } receiveValue: { response in
                print(response)
                guard self.unlockService.handleResponse(response) == .success else { return }
                self.getBlockedUserList()
                self.bridgeUnblockedUser(unblockedUserId: userId)
            }
            .store(in: &subscription)
    }
}
