//
//  GitHub.User.mock.swift
//  FluxWithRxSwiftTests
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

extension GitHub.User {
    static func mock() -> GitHub.User {
        return GitHub.User(login: "marty-suzuki",
                           id: 1,
                           nodeID: "nodeID",
                           avatarURL: URL(string: "https://avatars1.githubusercontent.com")!,
                           gravatarID: "",
                           url: URL(string: "https://github.com/marty-suzuki")!,
                           receivedEventsURL: URL(string: "https://github.com/marty-suzuki")!,
                           type: "User")
    }
}
