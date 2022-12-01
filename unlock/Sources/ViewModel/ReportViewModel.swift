//
//  ReportViewModel.swift
//  unlock
//
//  Created by Paul Lee on 2022/12/01.
//

import Foundation
import Alamofire
import Combine
import Moya

class ReportViewModel: ObservableObject {
    private let provider = MoyaProvider<UnlockAPI>(session: Moya.Session(interceptor: Interceptor()), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var subscription = Set<AnyCancellable>()

    private let unlockService = UnlockService.shared

    @Published var reportSuccess: Bool = false

    @Published var reportType: ReportType = .post
    @Published var postID: String? = nil
    @Published var commentID: String? = nil

    @Published var reportSuccessAlertText: String = "게시물 신고가 완료되었습니다."

    init() {
        print("Report ViewModel Created")
    }

    func setPostAndCommentID(postID: String?, commentID: String?) {
        self.postID = postID
        self.commentID = commentID

        self.reportType = postID != nil ? .post : .comment
        self.reportSuccessAlertText = postID != nil ? "게시물 신고가 완료되었습니다." : "댓글 신고가 완료되었습니다."
    }

    func report(reason: Int, content: String) {
        unlockService.isLoading = true

        provider.requestPublisher(.postReport(type: reportType.rawValue, postId: postID, commentId: commentID, reason: reason, content: content))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("Report failed: " + error.localizedDescription)
                case .finished:
                    print("Report finished")
                }
            } receiveValue: { response in
                guard self.unlockService.handleResponse(response) == .success else { return }
                guard let _ = try? response.map(ReportResponse.self) else { return }
                self.reportSuccess = true
            }
            .store(in: &subscription)
    }
}
