//
//  Session.swift
//  GitHub
//
//  Created by 鈴木大貴 on 2018/08/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

public enum SessionError: Error {

    case noData(HTTPURLResponse)
    case noResponse
    case unacceptableStatusCode(Int, Message?)
    case failedToCreateComponents(URL)
    case failedToCreateURL(URLComponents)
}

public final class Session {

    private let accessToken: () -> AccessToken?
    private let additionalHeaderFields: () -> [String: String]?
    private let session: URLSession

    public init(accessToken: @escaping () -> AccessToken? = { nil },
                additionalHeaderFields: @escaping () -> [String: String]? = { nil },
                session: URLSession = .shared) {
        self.accessToken = accessToken
        self.additionalHeaderFields = additionalHeaderFields
        self.session = session
    }

    @discardableResult
    public func send<T: Request>(_ request: T,
                                 completion: @escaping (Result<(T.Response, Pagination)>) -> ()) -> URLSessionTask? {
        let url = request.baseURL.appendingPathComponent(request.path)

        guard var componets = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(SessionError.failedToCreateComponents(url)))
            return nil
        }
        componets.queryItems = request.queryParameters?.compactMap(URLQueryItem.init)

        guard var urlRequest = componets.url.map({ URLRequest(url: $0) }) else {
            completion(.failure(SessionError.failedToCreateURL(componets)))
            return nil
        }

        urlRequest.httpMethod = request.method.rawValue

        let headerFields: [String: String]
        if let additionalHeaderFields = additionalHeaderFields() {
            headerFields = request.headerFields.merging(additionalHeaderFields, uniquingKeysWith: +)
        } else {
            headerFields = request.headerFields
        }
        if let token = accessToken() {
            let authorization = ["Authorization": "token \(token.accessToken)"]
            urlRequest.allHTTPHeaderFields = headerFields.merging(authorization, uniquingKeysWith: +)
        } else {
            urlRequest.allHTTPHeaderFields = headerFields
        }

        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(SessionError.noResponse))
                return
            }

            guard let data = data else {
                completion(.failure(SessionError.noData(response)))
                return
            }

            guard  200..<300 ~= response.statusCode else {
                let message = try? JSONDecoder().decode(SessionError.Message.self, from: data)
                completion(.failure(SessionError.unacceptableStatusCode(response.statusCode, message)))
                return
            }

            let pagination: Pagination
            if let link = response.allHeaderFields["Link"] as? String {
                pagination = Pagination(link: link)
            } else {
                pagination = Pagination(next: nil, last: nil, first: nil, prev: nil)
            }

            do {
                let object = try JSONDecoder().decode(T.Response.self, from: data)
                completion(.success((object, pagination)))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()

        return task
    }
}

extension SessionError {
    public struct Message: Decodable {
        public let documentationURL: URL
        public let message: String

        private enum CodingKeys: String, CodingKey {
            case documentationURL = "documentation_url"
            case message
        }
    }
}
