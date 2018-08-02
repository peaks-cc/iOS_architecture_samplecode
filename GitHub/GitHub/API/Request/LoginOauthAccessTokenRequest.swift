//
//  LoginOauthAccessTokenRequest.swift
//  GitHub
//
//  Created by marty-suzuki on 2018/08/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

internal struct LoginOauthAccessTokenRequest: Request {
    typealias Response = AccessToken

    let baseURL = URL(string: "https://github.com")!
    let method: HttpMethod = .post
    let path = "/login/oauth/access_token"

    var queryParameters: [String : String]? {
        let params: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": code
        ]
        return params
    }

    let clientID: String
    let clientSecret: String
    let code: String

    init(clientID: String, clientSecret: String, code: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.code = code
    }
}
