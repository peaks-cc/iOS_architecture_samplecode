//
//  GitHubClient.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

class GitHubClient {

    func fetchRepositoryList(completionHandler: () -> ()) {
        let url = URL(string: "https://api.github.com/search/repositories?q=language:swift")!
        let decoder = JSONDecoder()

        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let items = try decoder.decode(Items.self, from: data!)
                print(items)
            } catch {
                print(error)
            }
        }

        session.resume()
    }

}
