//
//  Github.ApiSession.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

protocol GithubApiRequestable: class {
    func searchUsers(query: String, completion: @escaping (Github.Result<[Github.User]>) -> ())
    func repositories(username: String, completion: @escaping (Github.Result<[Github.Repository]>) -> ())
}

extension Github {
    enum Result<T> {
        case success(T)
        case failure(Swift.Error)
    }

    final class ApiSession: GithubApiRequestable {
        static let shared = ApiSession()

        enum Error: Swift.Error {
            case noData(HTTPURLResponse)
            case noResponse
            case failedToCreateComponents(URL)
            case failedToCreateURL(URLComponents)
        }

        private let session = URLSession.shared
        private let baseURL = URL(string: "https://api.github.com")!

        private func sendRequest<T: Decodable>(path: String, query: [String: String]?, completion: @escaping (Result<T>) -> ()) {
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

                guard let data = data else {
                    if let resposne = response as? HTTPURLResponse {
                        completion(.failure(Error.noData(resposne)))
                    } else {
                        completion(.failure(Error.noResponse))
                    }
                    return
                }

                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }

        func searchUsers(query: String, completion: @escaping (Result<[User]>) -> ()) {
            sendRequest(path: "/search/users", query: ["q": query]) { (result: Result<ItemsResponse<User>>) in
                switch result {
                case let .success(reponse):
                    completion(.success(reponse.items))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }

        func repositories(username: String, completion: @escaping (Result<[Repository]>) -> ()) {
            sendRequest(path: "/users/\(username)/repos", query: nil) { (result: Result<[Repository]>) in
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
