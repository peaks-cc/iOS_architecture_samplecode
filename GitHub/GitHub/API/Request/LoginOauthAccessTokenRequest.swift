//
//  LoginOauthAccessTokenRequest.swift
//  GitHub
//
//  Created by marty-suzuki on 2018/08/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

public struct LoginOauthAccessTokenRequest: Request {
    public typealias Response = AccessToken

    public let baseURL = URL(string: "https://github.com")!
    public let method: HttpMethod = .post
    public let path = "/login/oauth/access_token"

    public var queryParameters: [String : String]? {
        let params: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": code
        ]
        return params
    }

    public let clientID: String
    public let clientSecret: String
    public let code: String

    public init(clientID: String, clientSecret: String, code: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.code = code
    }
}
