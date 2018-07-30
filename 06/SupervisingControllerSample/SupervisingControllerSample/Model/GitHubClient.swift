//
//  GitHubClient.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

class GitHubClient {

    func fetchRepositoryList(completionHandler: @escaping (Result<[Repository]>) -> ()) {
        let url = URL(string: "https://api.github.com/search/repositories?q=language:swift")!

        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.error(error))
                return
            }

            let response = response as! HTTPURLResponse

            let statusCode = response.statusCode
            if !(200..<300 ~= statusCode) {
                let httpError = HTTPError(code: statusCode)
                completionHandler(.error(httpError))
                return
            }

            let decoder = JSONDecoder()

            do {
                let items = try decoder.decode(Items.self, from: data!)
                completionHandler(.success(items.repositories))
            } catch {
                completionHandler(.error(error))
            }
        }

        session.resume()
    }

}
