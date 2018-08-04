//
//  User.swift
//  GitHub
//
//  Created by 鈴木大貴 on 2018/08/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let login: String
    public let id: Int
    public let nodeID: String
    public let avatarURL: URL
    public let gravatarID: String
    public let url: URL
    public let receivedEventsURL: URL
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case receivedEventsURL = "received_events_url"
        case type
    }

    public init(login: String,
                id: Int,
                nodeID: String,
                avatarURL: URL,
                gravatarID: String,
                url: URL,
                receivedEventsURL: URL,
                type: String) {
        self.login = login
        self.id = id
        self.nodeID = nodeID
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
        self.url = url
        self.receivedEventsURL = receivedEventsURL
        self.type = type
    }
}
