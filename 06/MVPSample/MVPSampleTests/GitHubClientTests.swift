//
//  GitHubClientTests.swift
//  MVPSampleTests
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import XCTest
import Mockingjay
@testable import MVPSample

class GitHubClientTests: XCTestCase {
    func testAPI呼び出しでHTTPエラーが返ってくる() {
        XCTContext.runActivity(named: "HTTPステータスコードが404だった場合、HTTPError.notFoundが返却されること") { _ in
            let request = http(.get, uri: "https://api.github.com/search/repositories?q=language:swift")
            let response = http(404, headers: nil)
            stub(request, response)

            let exp = expectation(description: #function)

            let client = GitHubClient()
            client.fetchRepositoryList { result in
                switch result {
                case .error(let error):
                    let httpError = error as! HTTPError
                    XCTAssertEqual(HTTPError.notFound, httpError)
                    exp.fulfill()
                case .success:
                    XCTFail()
                    exp.fulfill()
                }
            }

            wait(for: [exp], timeout: 2.0)
        }
    }

    func testリポジトリ一覧が返ってくること() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "Repositories", ofType: "json")!
        let url = URL(string: "file://" + path)!
        let data = try Data(contentsOf: url)
        let anyJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

        let request = http(.get, uri: "https://api.github.com/search/repositories?q=language:swift")
        stub(request, json(anyJson))

        let exp = expectation(description: #function)

        let decoder = JSONDecoder()
        let items = try decoder.decode(Items.self, from: data)
        let expect = Items(repositories: items.repositories).repositories

        let client = GitHubClient()
        client.fetchRepositoryList { result in
            switch result {
            case .error:
                XCTFail()
                exp.fulfill()
            case .success(let repositories):
                XCTAssertEqual(expect, repositories)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 2.0)
    }
}
