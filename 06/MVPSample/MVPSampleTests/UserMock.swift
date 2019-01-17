//
//  UserMock.swift
//  MVPSampleTests
//
//  Created by koichi.tanaka on 2019/01/12.
//  Copyright © 2019年 Kenji Tanaka. All rights reserved.
//

import GitHub

extension User {
    static func mock() -> User {
        let u = User(login: "",
                     id: 1,
                     nodeID: "",
                     avatarURL: URL.init(string: "https://google.com")!,
                     gravatarID: "",
                     url: URL.init(string: "https://google.com")!,
                     receivedEventsURL: URL.init(string: "https://google.com")!,
                     type: "")
        return u
    }
}
