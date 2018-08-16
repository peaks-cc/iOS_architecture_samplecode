//
//  SearchUsersViewModelTests.swift
//  FluxPlusExampleTests
//
//  Created by 鈴木大貴 on 2018/08/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift
import XCTest
@testable import FluxPlusExample

final class SearchUsersViewModelTests: XCTestCase {

    private struct Dependency {

        let apiSession = MockGitHubApiSession()

        let actionCreator: GitHubUserActionCreator
        let store: GitHubUserStore
        let dispatcher: GitHubUserDispatcher

        let viewModel: SearchUsersViewModel

        let searchText = PublishRelay<String?>()
        let cancelButtonClicked = PublishRelay<Void>()
        let textDidBeginEditing = PublishRelay<Void>()
        let searchButtonClicked = PublishRelay<Void>()

        init() {
            let flux = Flux.make(apiSession: apiSession)

            self.actionCreator = flux.userActionCreator
            self.store = flux.userStore
            self.dispatcher = flux.userDispatcher

            self.viewModel = SearchUsersViewModel(searchText: searchText.asObservable(),
                                                  cancelButtonClicked: cancelButtonClicked.asObservable(),
                                                  textDidBeginEditing: textDidBeginEditing.asObservable(),
                                                  searchButtonClicked: searchButtonClicked.asObservable(),
                                                  flux: flux)
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

    func testSearchUsers() {
        let query = "username"

        let expect = expectation(description: "waiting apiSession.searchUsersParams")
        let disposable = dependency.apiSession.searchUsersParams
            .subscribe(onNext: { _query, _page in
                XCTAssertEqual(_query, _query)
                XCTAssertEqual(_page, 1)
                expect.fulfill()
            })

        dependency.searchText.accept(query)
        dependency.searchButtonClicked.accept(())
        wait(for: [expect], timeout: 0.1)

        disposable.dispose()
    }

    func testReloadDataAndUsers() {
        XCTAssertTrue(dependency.viewModel.users.value.isEmpty)

        let users = [makeUser(), makeUser()]

        let expect = expectation(description: "waiting viewModel.reloadData")
        let disposable = dependency.viewModel.reloadData
            .skip(1)
            .subscribe(onNext: {
                expect.fulfill()
            })

        dependency.dispatcher.addUsers.accept(users)
        wait(for: [expect], timeout: 0.1)
        disposable.dispose()

        XCTAssertEqual(dependency.viewModel.users.value.count, users.count)
        XCTAssertNotNil(dependency.viewModel.users.value.first)
        XCTAssertEqual(dependency.viewModel.users.value.first?.login, users.first?.login)
    }
}
