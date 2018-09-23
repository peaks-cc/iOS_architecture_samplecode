//
//  UserDefaultsDataStore.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/21.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

class UserDefaultsDataStore: LikesGatewayProtocol {
    func fetch(byNames names: [String], completion: (Result<[Like]>) -> Void) {

        let likes = names.map { UserDefaults.standard.object(forKey: $0) }
            .compactMap { $0 as? Like }
        completion(Result.success(likes))
    }

    func save(liked: Bool, for repo: GitHubRepo, completion: (Result<Like>) -> Void) {

        let encoder = JSONEncoder()
        do {
            let like: Like = .init(id: repo.id, isLiked: liked)

            let data = try encoder.encode(like)
            let jsonstr: String = String(data: data, encoding: .utf8)!
            print(jsonstr)
            UserDefaults.standard.set(jsonstr, forKey: repo.fullName)
            completion(Result.success(like))
        } catch { print(error.localizedDescription) }
    }
}
