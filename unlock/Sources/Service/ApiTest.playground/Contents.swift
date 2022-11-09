import UIKit
import Moya
import Alamofire

var greeting = "Hello, playground"



private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()))

// provider.request(.login(email: "paullee20204@gmail.com", password: "paul0402")) { response in
provider.request(.userLoggedIn(token: "")) { response in
    switch response {
    case .success(let result):
        
        guard let data = try? result.map(Bool.self) else {
            print("Failed")
            return
        }
        
        print(data)
    case .failure(let error):
        print("Hello")
        print(error.localizedDescription)
    }
}

print("???")
