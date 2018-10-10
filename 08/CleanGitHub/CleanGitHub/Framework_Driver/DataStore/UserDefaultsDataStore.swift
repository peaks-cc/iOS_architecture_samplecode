//
//  UserDefaultsDataStore.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/21.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Bool, forKey defaultName: String)
}
extension UserDefaults: UserDefaultsProtocol {}

final class UserDefaultsDataStore: DataStoreProtocol {
    let userDefaults: UserDefaultsProtocol
    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }
    func fetch(ids: [GitHubRepo.ID], completion: (Result<[GitHubRepo.ID: Bool]>) -> Void) {
        let idsAndLikes: [(GitHubRepo.ID, Bool)] = ids.map { id in
            (id, userDefaults.bool(forKey: id.rawValue))
        }
        let result = Dictionary(uniqueKeysWithValues: idsAndLikes)
        completion(.success(result))
    }
    func save(liked: Bool, for id: GitHubRepo.ID, completion: (Result<Bool>) -> Void) {
        userDefaults.set(liked, forKey: id.rawValue)
        completion(.success(liked))
    }
}
