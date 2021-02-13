//
//  GitHubApiSession.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift

protocol GitHubApiRequestable: class {
    func searchRepositories(query: String, page: Int)  -> Observable<([GitHub.Repository], GitHub.Pagination)>
}

final class GitHubApiSession: GitHubApiRequestable {
    static let shared = GitHubApiSession()

    private let session = GitHub.Session()

    func searchRepositories(query: String, page: Int)  -> Observable<([GitHub.Repository], GitHub.Pagination)> {
        return Single.create { [session] event in
            let request = SearchRepositoriesRequest(query: query, sort: .stars, order: .desc, page: page, perPage: nil)
            let task = session.send(request) { result in
                switch result {
                case let .success((response, pagination)):
                    event(.success((response.items, pagination)))
                case let .failure(error):
                    event(.failure(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
        .asObservable()
    }
}
