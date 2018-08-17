//
//  SearchUsersViewControllerTests.swift
//  FluxExampleTests
//
//  Created by marty-suzuki on 2018/08/05.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import GitHub
@testable import FluxExample

final class SearchUsersViewControllerTests: XCTestCase {

    private struct Dependency {
        let apiSession = MockGitHubApiSession()
        let localCache = MockLocalCache()

        let dispatcher = Dispatcher()
        let actionCreator: ActionCreator
        let store: GitHubUserStore

        let viewController: SearchUsersViewController

        init() {
            self.actionCreator = ActionCreator(dispatcher: dispatcher,
                                               apiSession: apiSession,
                                               localCache: localCache)
            self.store = GitHubUserStore(dispatcher: dispatcher)
            self.viewController = SearchUsersViewController(userStore: store,
                                                            actionCreator: actionCreator)
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
        dependency.apiSession.searchUsersParams = { _query, _page in
            XCTAssertEqual(_query, query)
            XCTAssertEqual(_page, 1)
            expect.fulfill()
        }

        let searchBar = dependency.viewController.searchBar!
        searchBar.text = query
        searchBar.delegate!.searchBarSearchButtonClicked!(searchBar)
        wait(for: [expect], timeout: 0.1)
    }

    func testReloadData() {
        let tableView = dependency.viewController.tableView!
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)

        let users = [makeUser(), makeUser()]
        dependency.dispatcher.dispatch(.addUsers(users))

        let expect = expectation(description: "waiting view reflection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), users.count)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 1.1)
    }
}
