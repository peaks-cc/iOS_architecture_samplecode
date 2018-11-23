//
// Created by Kenji Tanaka on 2018/09/26.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import GitHub
import RxSwift

protocol UserDetailModelInput {
    func fetchRepositories() -> Observable<[Repository]>
}

final class UserDetailModel: UserDetailModelInput {
    let session = Session()

    private let userName: GitHub.User.Name
    init(userName: GitHub.User.Name) {
        self.userName = userName
    }

    func fetchRepositories() -> Observable<[Repository]> {
        return Observable.create { [weak self] observer in
            guard let me = self else { return Disposables.create() }

            let request = UserReposRequest(username: me.userName.rawValue, type: nil, sort: nil, direction: nil, page: nil, perPage: nil)
            let task = me.session.send(request) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response.0)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
