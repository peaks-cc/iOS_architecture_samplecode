//
//  RepositoryListPresenter.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

class RepositoryListPresenter {

    private let gitHubClient = GitHubClient()

    func viewDidLoad() {
        gitHubClient.getRepositoryList {
            ()
        }
    }

}
