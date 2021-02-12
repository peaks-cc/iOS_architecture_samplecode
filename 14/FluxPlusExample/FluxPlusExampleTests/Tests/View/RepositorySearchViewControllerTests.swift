//
//  RepositorySearchViewControllerTests.swift
//  FluxPlusExampleTests
//
//  Created by marty-suzuki on 2018/09/25.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import GitHub
import RxCocoa
import RxSwift
@testable import FluxPlusExample

final class RepositorySearchViewControllerTests: XCTestCase {

    private struct Dependency {
        let apiSession = MockGitHubApiSession()
        let searchRepositoryDispatcher: SearchRepositoryDispatcher
        let viewController: RepositorySearchViewController

        init() {
            let flux = Flux.mock(apiSession: apiSession)
            self.searchRepositoryDispatcher = flux.searchRepositoryDispatcher
            self.viewController = RepositorySearchViewController(flux: flux)
            viewController.loadViewIfNeeded()
        }
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }

    func testReloadData() {
        let tableView: UITableView = dependency.viewController.tableView
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)

        let repositories = [GitHub.Repository.mock(), GitHub.Repository.mock()]
        dependency.searchRepositoryDispatcher.addRepositories.accept(repositories)

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), repositories.count)
    }

    func testSearchButtonClicked() {
        let query = "username"

        let expect = expectation(description: "waiting called apiSession.searchUsers")
        let disposable = dependency.apiSession.searchRepositoriesParams
            .subscribe(onNext: { _query, _page in
                XCTAssertEqual(_query, query)
                XCTAssertEqual(_page, 1)
                expect.fulfill()
            })

        let searchBar: UISearchBar = dependency.viewController.searchBar
        searchBar.text = query
        searchBar.delegate!.searchBar!(searchBar, textDidChange: query)
        searchBar.delegate!.searchBarSearchButtonClicked!(searchBar)

        wait(for: [expect], timeout: 0.1)
        disposable.dispose()
    }
}
