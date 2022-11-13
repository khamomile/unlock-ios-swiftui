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
