//
//  SearchUserPresenterTests.swift
//  MVPSampleTests
//
//  Created by koichi.tanaka on 2019/01/05.
//  Copyright © 2019年 koichi.tanaka. All rights reserved.
//

import XCTest
@testable import MVPSample
@testable import GitHub

class SearchUserPresenterOutputSpy: SearchUserPresenterOutput {
    private(set) var countOfInvokingUpdateUsers: Int = 0
    private(set) var countOfInvokingTransitionToUserDetail: Int = 0
    
    var updateUsersCalledWithUsers: (([User]) -> Void)?
    var transitionToUserDetailCalledWithUserName: ((String) -> Void)?
    
    func updateUsers(_ users: [User]) {
        countOfInvokingUpdateUsers += 1
        updateUsersCalledWithUsers?(users)
    }
    
    func transitionToUserDetail(userName: String) {
        countOfInvokingTransitionToUserDetail += 1
        transitionToUserDetailCalledWithUserName?(userName)
    }
}

class SearchUserModelInputStub: SearchUserModelInput {
    private var fetchUserResponses: [String: Result<[User]>] = [:]

    func addFetchUserResponse(_ result: Result<[User]>, whenQuery query: String) {
        fetchUserResponses[query] = result
    }

    func fetchUser(query: String, completion: @escaping (Result<[User]>) -> ()) {
        guard let response = fetchUserResponses[query] else {
            fatalError("fetchUserResponse not found when query is \(query)")
        }
        completion(response)
    }
}

extension SearchUserModelInputStub {
    struct Error: Swift.Error{}
}

class SearchUserPresenterTests: XCTestCase {
    
    override func setUp() {
    }

    override func tearDown() {
    }

    func testDidTapSearchButton() {
        XCTContext.runActivity(named: "検索ボタンタップ時処理") { _ in
            XCTContext.runActivity(named: "ユーザー検索成功時にView更新処理が呼ばれること") { _ in
                let spy = SearchUserPresenterOutputSpy()
                let stub = SearchUserModelInputStub()
                let presenter = SearchUserPresenter(view: spy, model: stub)
                let query = "query"
                let users = [User.mock()]
                stub.addFetchUserResponse(.success(users), whenQuery: query)
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるupdateUsersの実行を待つ")
                spy.updateUsersCalledWithUsers = { users in
                    exp.fulfill()
                }
                
                presenter.didTapSearchButton(text: query)
                wait(for: [exp], timeout: 1)
                
                XCTAssertTrue(presenter.numberOfUsers == 1)
                XCTAssertTrue(spy.countOfInvokingUpdateUsers == 1)
            }
            XCTContext.runActivity(named: "ユーザー検索失敗時はView更新処理が呼ばれないこと") { _ in
                let spy = SearchUserPresenterOutputSpy()
                let stub = SearchUserModelInputStub()
                let presenter = SearchUserPresenter(view: spy, model: stub)
                let query = "query"
                let error = SearchUserModelInputStub.Error()
                stub.addFetchUserResponse(.failure(error), whenQuery: query)
        
                presenter.didTapSearchButton(text: query)

                XCTAssertTrue(presenter.numberOfUsers == 0)
                XCTAssertTrue(spy.countOfInvokingUpdateUsers == 0)
            }
        }
    }

    func testDidSelectRow() {
        XCTContext.runActivity(named: "セル選択時処理") { _ in
            XCTContext.runActivity(named: "成功時にユーザー詳細への遷移処理が呼ばれること") { _ in
                let spy = SearchUserPresenterOutputSpy()
                let stub = SearchUserModelInputStub()
                let presenter = SearchUserPresenter(view: spy, model: stub)
                let query = "query"
                let users = [User.mock()]
                stub.addFetchUserResponse(.success(users), whenQuery: query)
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるupdateUsersの実行を待つ")
                spy.updateUsersCalledWithUsers = { users in
                    exp.fulfill()
                }
                
                presenter.didTapSearchButton(text: query)
                wait(for: [exp], timeout: 1)
                
                XCTAssertTrue(spy.countOfInvokingTransitionToUserDetail == 0)
                presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(spy.countOfInvokingTransitionToUserDetail == 1)
            }
            XCTContext.runActivity(named: "失敗時にユーザー詳細への遷移処理が呼ばれないこと") { _ in
                let spy = SearchUserPresenterOutputSpy()
                let stub = SearchUserModelInputStub()
                let presenter = SearchUserPresenter(view: spy, model: stub)
                let query = "query"
                let error = SearchUserModelInputStub.Error()
                stub.addFetchUserResponse(.failure(error), whenQuery: query)
                
                presenter.didTapSearchButton(text: "query")

                XCTAssertTrue(spy.countOfInvokingTransitionToUserDetail == 0)
                presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(spy.countOfInvokingTransitionToUserDetail == 0)
            }
        }
    }
}
