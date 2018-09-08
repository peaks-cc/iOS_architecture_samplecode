//
//  SearchUsersViewControllerTests.swift
//  FluxWithRxSwiftTests
//
//  Created by 鈴木大貴 on 2018/08/19.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import GitHub
@testable import FluxWithRxSwift

final class SearchUsersViewControllerTests: XCTestCase {

    private struct Dependency {
        let apiSession = MockGitHubApiSession()
        let localCache = MockLocalCache()

        let dispatcher: GitHubUserDispatcher
        let actionCreator: GitHubUserActionCreator
        let store: GitHubUserStore

        let viewController: SearchUsersViewController

        init() {
            let flux = Flux.mock(apiSession: apiSession, localCache: localCache)
            self.dispatcher = flux.userDispatcher
            self.actionCreator = flux.userActionCreator
            self.store = flux.userStore
            self.viewController = SearchUsersViewController(flux: flux)
            viewController.loadViewIfNeeded()
        }
    }

    private func makeUser() -> GitHub.User {
        return GitHub.User(login: "username",
                           id: 1,
                           nodeID: "",
                           avatarURL: URL(string: "https://github.com/")!,
                           gravatarID: "",
                           url: URL(string: "https://github.com/")!,
                           receivedEventsURL: URL(string: "https://github.com/")!,
                           type: "")
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }

    func testSearchButtonClicked() {
        let query = "username"

        let expect = expectation(description: "waiting called apiSession.searchUsers")
        let disposable = dependency.apiSession.searchUsersParams
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

        let users = [makeUser(), makeUser()]
        dependency.dispatcher.addUsers.accept(users)

        let expect = expectation(description: "waiting view reflection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), users.count)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 1.1)
    }
}
