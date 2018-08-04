//
//  AccessToken.swift
//  GitHub
//
//  Created by marty-suzuki on 2018/08/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

public struct AccessToken: Codable {
    public let accessToken: String
    public let tokenType: String
    public let scope: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }

    public init(accessToken: String, tokenType: String, scope: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.scope = scope
    }
}
