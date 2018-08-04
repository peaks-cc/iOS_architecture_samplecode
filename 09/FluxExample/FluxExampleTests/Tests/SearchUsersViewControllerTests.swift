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

    private func makePagination() -> GitHub.Pagination {
        return GitHub.Pagination(next: nil, last: nil, first: nil, prev: nil)
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }
    
    func testSearchButtonClicked() {
        let query = "username"
        let users = [makeUser()]
        let pagination = makePagination()
        dependency.apiSession.searchUsersResult = .success((users, pagination))

        let expect1 = expectation(description: "waiting Action.addUsers")
        let expect2 = expectation(description: "waiting Action.searchQuery")
        let expect3 = expectation(description: "waiting Action.clearUsers")
        _ = dependency.dispatcher.register { action in
            switch action {
            case let .addUsers(_users):
                XCTAssertEqual(_users.count, users.count)
                XCTAssertNotNil(_users.first)
                XCTAssertEqual(_users.first?.login, users.first?.login)
                expect1.fulfill()
            case let .searchQuery(_query):
                XCTAssertEqual(_query, query)
                expect2.fulfill()
            case .clearUsers:
                expect3.fulfill()
            case .isSeachUsersFieldEditing,
                 .isSearchUsersFetching,
                 .searchUsersPagination:
                return
            default:
                XCTFail("Unexpected Action: \(action)")
            }
        }

        let searchBar = dependency.viewController.searchBar!
        searchBar.text = query
        searchBar.delegate!.searchBarSearchButtonClicked!(searchBar)
        wait(for: [expect1, expect2, expect3], timeout: 0.1)
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
