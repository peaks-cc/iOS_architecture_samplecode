//
//  GitHub.ApiSession.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

protocol GitHubApiRequestable: class {
    func searchUsers(query: String, page: Int, completion: @escaping (GitHub.Result<([GitHub.User], GitHub.Pagination)>) -> ())
    func repositories(username: String, completion: @escaping (GitHub.Result<([GitHub.Repository], GitHub.Pagination)>) -> ())
}

extension GitHub {
    enum Result<T> {
        case success(T)
        case failure(Swift.Error)
    }

    final class ApiSession: GitHubApiRequestable {
        static let shared = ApiSession()

        enum Error: Swift.Error {
            case noData(HTTPURLResponse)
            case noResponse
            case failedToCreateComponents(URL)
            case failedToCreateURL(URLComponents)
        }

        private let session = URLSession.shared
        private let baseURL = URL(string: "https://api.github.com")!

        private func sendRequest<T: Decodable>(path: String, query: [String: String]?, completion: @escaping (Result<(T, Pagination)>) -> ()) {
            let url = baseURL.appendingPathComponent(path)

            guard var componets = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                completion(.failure(Error.failedToCreateComponents(url)))
                return
            }
            componets.queryItems = query?.compactMap(URLQueryItem.init)

            guard var request = componets.url.map({ URLRequest(url: $0) }) else {
                completion(.failure(Error.failedToCreateURL(componets)))
                return
            }
            request.httpMethod = "GET"

            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let resposne = response as? HTTPURLResponse else {
                    completion(.failure(Error.noResponse))
                    return
                }

                guard let data = data else {
                    completion(.failure(Error.noData(resposne)))
                    return
                }

                let pagination: Pagination
                if let link = resposne.allHeaderFields["Link"] as? String {
                    pagination = Pagination(link: link)
                } else {
                    pagination = Pagination(next: nil, last: nil, first: nil, prev: nil)
                }

                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success((object, pagination)))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }

        func searchUsers(query: String, page: Int, completion: @escaping (Result<([User], Pagination)>) -> ()) {
            sendRequest(path: "/search/users", query: ["q": query, "page": "\(page)"]) { (result: Result<(ItemsResponse<User>, Pagination)>) in
                switch result {
                case let .success(reponse):
                    completion(.success((reponse.0.items, reponse.1)))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }

        func repositories(username: String, completion: @escaping (Result<([Repository], Pagination)>) -> ()) {
            sendRequest(path: "/users/\(username)/repos", query: nil) { (result: Result<([Repository], Pagination)>) in
                switch result {
                case let .success(reponse):
                    completion(.success(reponse))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
