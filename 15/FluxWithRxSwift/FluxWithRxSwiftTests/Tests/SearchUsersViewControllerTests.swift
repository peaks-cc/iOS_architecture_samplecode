//
//  SearchUsersViewControllerTests.swift
//  FluxWithRxSwiftTests
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import GitHub
@testable import FluxWithRxSwift

final class SearchUsersViewControllerTests: XCTestCase {

    private struct Dependency {
        let apiSession = MockGitHubApiSession()
        let localCache = MockLocalCache()

        let dispatcher = Dispatcher()

        let viewController: RepositorySearchViewController

        init() {
            let actionCreator = ActionCreator(dispatcher: dispatcher,
                                              apiSession: apiSession,
                                              localCache: localCache)
            let searchRepositoryStore = SearchRepositoryStore(dispatcher: dispatcher)
            let selectedRepositoryStore = SelectedRepositoryStore(dispatcher: dispatcher)
            self.viewController = RepositorySearchViewController(actionCreator: actionCreator,
                                                                 searchRepositoryStore: searchRepositoryStore,
                                                                 selectedRepositoryStore: selectedRepositoryStore)
            viewController.loadViewIfNeeded()
        }
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }

    func testSearchButtonClicked() {
        let query = "username"

        let expect = expectation(description: "waiting called apiSession.searchRepositories")
        let disposable = dependency.apiSession.searchRepositoriesParams
            .subscribe(onNext: { _query, _page in
                XCTAssertEqual(_query, query)
                XCTAssertEqual(_page, 1)
                expect.fulfill()
            })

        let searchBar = dependency.viewController.searchBar!
        searchBar.text = query
        searchBar.delegate!.searchBar!(searchBar, textDidChange: query)
        searchBar.delegate!.searchBarSearchButtonClicked!(searchBar)
        wait(for: [expect], timeout: 1)
        disposable.dispose()
    }

    func testReloadData() {
        let tableView = dependency.viewController.tableView!
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)

        let repositories: [GitHub.Repository] = [.mock(), .mock()]
        dependency.dispatcher.dispatch(.searchRepositories(repositories))

        let expect = expectation(description: "waiting view reflection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), repositories.count)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 1.1)
    }
}
