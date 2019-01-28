//
//  URLRequest+RxSwift.swift
//  CleanArchitectureExample
//
//  Created by Daiki Matsudate on 2018/07/22.
//  Copyright © 2018 Daiki Matsudate. All rights reserved.
//

import Foundation
import RxSwift

struct Response<T: Codable> {
    let body: T
    let header: [AnyHashable: Any]
    let statusCode: Int
}

extension URLRequest {
    func response<T: Codable>() -> Observable<Response<T>> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: self,
                    completionHandler: { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else {
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                do {
                    let body = try JSONDecoder().decode(T.self, from: data)
                    let header = response.allHeaderFields.compactMapValues({$0})
                    let statusCode = response.statusCode
                    let model = Response<T>(body: body,
                                            header: header,
                                            statusCode: statusCode)
                    observer.onNext(model)
                } catch {
                    observer.onError(error)
                }
            })
            task.resume()
            return Disposables.create()
        }
    }
}
