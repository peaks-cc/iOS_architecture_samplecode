//
//  GitHubGatewayImpl.swift
//  CleanArchitectureExample
//
//  Created by Daiki Matsudate on 2018/07/22.
//  Copyright © 2018 Daiki Matsudate. All rights reserved.
//

import Foundation
import RxSwift

struct GitHubGatewayImpl: GitHubGateway {
    private func search(
        url: GitHub.Endpoint,
        q: String, sort: String? = nil,
        order: GitHub.Order = .desc
        ) -> Observable<Response<GitHubRepoEntity>> {

        var components = URLComponents(url: url.url,
                                       resolvingAgainstBaseURL: true)!
        components.queryItems = [
            .init(name: "sort", value: sort),
            .init(name: "order", value: order.rawValue)
            ].compactMap { $0 }
        let request: URLRequest = {
            var request: URLRequest = .init(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            return request
        }()
        return request.response()
    }

    func search(
        repositories q: String,
        sort: GitHub.SearchRepositoriesSort? = nil,
        order: GitHub.Order = .desc
        ) -> Observable<Response<GitHubRepoEntity>> {
        return search(url: .searchRepositories,
                      q: q,
                      sort: sort?.rawValue,
                      order: order)
    }

    func search(
        commits q: String,
        sort: GitHub.SearchCommitsSort?,
        order: GitHub.Order
        ) -> Observable<Response<GitHubRepoEntity>> {
        return search(url: .searchCommits,
                      q: q,
                      sort: sort?.rawValue,
                      order: order)
    }

    func search(
        code q: String,
        sort: GitHub.SearchCodeSort?,
        order: GitHub.Order) -> Observable<Response<GitHubRepoEntity>> {
        return search(url: .searchCode,
                      q: q,
                      sort: sort?.rawValue,
                      order: order)
    }
}
