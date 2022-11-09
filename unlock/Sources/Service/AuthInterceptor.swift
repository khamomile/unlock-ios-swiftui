//
//  AuthInterceptor.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/27.
//

import Foundation
import Alamofire

class Interceptor : RequestInterceptor {
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var tokenUrlRequest = urlRequest
        
        tokenUrlRequest.headers.add(.authorization(bearerToken: "test"))
        
        // Add something in header
        // urlRequest.headers.add(name: "header name", value: "header value")
        
        completion(.success(urlRequest))
    }

    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void
    ) {
        // Retry request by statusCode type
        
        // guard let statusCode = request.response?.statusCode else { return }
        // switch statusCode {
        //    case .. : completion(.retry)
        // }
        
        completion(.doNotRetry)
    }
}

//import Foundation
//import Alamofire
//import Combine
//
//class AuthInterceptor: RequestInterceptor {
//
//    private var cancellables = Set<AnyCancellable>()
//    private let retryLimit = 3
//    private let retryDelay: TimeInterval = 1
//    private let refreshLimit = 1
//    private var refreshCount = 0
//
//    // REF: https://ios-development.tistory.com/730
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        var tokenUrlRequest = urlRequest
//
//        if tokenUrlRequest.url?.absoluteString.hasSuffix("refresh") == true,
//              let refreshToken = TokenUtils.loadRefreshToken() {
//            tokenUrlRequest.headers.add(.authorization(bearerToken: refreshToken))
//            completion(.success(tokenUrlRequest))
//            return
//        }
//
//        if let token = TokenUtils.loadAccessToken() {
//            tokenUrlRequest.headers.add(.authorization(bearerToken: token))
//            completion(.success(tokenUrlRequest))
//            return
//        }
//
//        completion(.failure(FirstTattooError.missingToken))
//
//    }
//
//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//
//        let response = request.response
//        print("RETRY [\(request.request?.url?.absoluteString)] AFTER REFRESH")
//        if let statusCode = response?.statusCode,
//           statusCode == 401,                       // response is unauthorized
//           request.retryCount < retryLimit {
//                if request.response?.url?.absoluteString.contains("refresh") ?? false {
//                    if refreshCount >= refreshLimit {
//                        DispatchQueue.main.async {
//                            print("CLEAR TOKENS DUE TO REFRESH")
//                            TokenUtils.clearTokens()
//                        }
//                        completion(.doNotRetryWithError(FirstTattooError.tokenError))
//                    }
//                    refreshCount = 0
//                }
//                else {
//                    // did not exceed retry limit
//                    if let refreshToken = TokenUtils.loadRefreshToken() {
//                        refreshCount += 1
//                        Networking.shared.refreshToken()
//                            .sink { response in
//                                self.refreshCount = 0
//                                response.saveNewTokens()
//                            }
//                            .store(in: &cancellables)
//                        completion(.retryWithDelay(retryDelay))
//                    }
//                }
//        } else {
//            completion(.doNotRetry)
//        }
//    }
//}
