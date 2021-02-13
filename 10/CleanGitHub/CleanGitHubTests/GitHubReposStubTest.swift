//
//  GitHubReposStubTest.swift
//  CleanGitHubTests
//
//  Created by 加藤寛人 on 2018/09/26.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import XCTest
@testable import CleanGitHub

class GitHubReposStubTest: XCTestCase {

    var repos: WebClientProtocol!

    override func setUp() {
        repos = GitHubReposStub()
    }

    override func tearDown() {
        repos = nil
    }

    func testGitHubReposStub() {
        repos!.fetch(using: [""]) { result in
            switch result {
            case .success(let repos):
                XCTAssert(!repos.isEmpty)
            default:
                XCTFail()
            }
        }
    }
}
