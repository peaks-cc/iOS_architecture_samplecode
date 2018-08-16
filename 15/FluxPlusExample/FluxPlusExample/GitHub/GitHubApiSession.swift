//
//  GitHubApiSession.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift

protocol GitHubApiRequestable: class {
    func searchUsers(query: String, page: Int) -> Observable<([GitHub.User], GitHub.Pagination)>
    func repositories(username: String, page: Int) -> Observable<([GitHub.Repository], GitHub.Pagination)>
}

final class GitHubApiSession: GitHubApiRequestable {
    static let shared = GitHubApiSession()

    private let session = GitHub.Session()

    func searchUsers(query: String, page: Int) -> Observable<([GitHub.User], GitHub.Pagination)> {
        return Single.create { [session] event in
            let request = SearchUsersRequest(query: query, sort: nil, order: nil, page: page, perPage: nil)
            let task = session.send(request) { result in
                switch result {
                case let .success(response, pagination):
                    event(.success((response.items, pagination)))
                case let .failure(error):
                    event(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
        .asObservable()
    }

    func repositories(username: String, page: Int) -> Observable<([GitHub.Repository], GitHub.Pagination)> {
        return Single.create { [session] event in
            let request = UserReposRequest(username: username, type: nil, sort: nil, direction: nil, page: page, perPage: nil)
            let task = session.send(request) { result in
                switch result {
                case let .success(response, pagination):
                    event(.success((response, pagination)))
                case let .failure(error):
                    event(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
        .asObservable()
    }
}
