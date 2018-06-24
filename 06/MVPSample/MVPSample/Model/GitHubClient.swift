//
//  GitHubClient.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

class GitHubClient {

    func getRepositoryList(completionHandler: () -> ()) {
        let url = URL(string: "https://api.github.com/search/repositories?q=language:swift")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
            } catch {
                print(error)
            }
        }

        session.resume()
    }

}
