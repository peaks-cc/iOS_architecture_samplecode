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

// プレゼンターの出力を記録するSpy
class SearchUserPresenterOutputSpy: SearchUserPresenterOutput {
    var countOfInvokingUpdateUsers: Int = 0
    var countOfInvokingTransitionToUserDetail: Int = 0
    
    func updateUsers(_ users: [User]) {
        countOfInvokingUpdateUsers += 1
    }
    
    func transitionToUserDetail(userName: String) {
        countOfInvokingTransitionToUserDetail += 1
    }
}

// Stubで利用する為のエラー
struct Err: Error {
}

// ユーザー検索処理の成功/失敗を切り替え可能にしたStub
class SearchUserModelInputStub: SearchUserModelInput {
    var shouldSuccess = true
    
    init(shouldSuccess: Bool = true) {
        self.shouldSuccess = shouldSuccess
    }
    
    func fetchUser(query: String, completion: @escaping (Result<[User]>) -> ()) {
        let users: [User] = {
            let u = User(login: "",
                         id: 1,
                         nodeID: "",
                         avatarURL: URL.init(string: "https://google.com")!,
                         gravatarID: "",
                         url: URL.init(string: "https://google.com")!,
                         receivedEventsURL: URL.init(string: "https://google.com")!,
                         type: "")
            return [u]
        }()
        if shouldSuccess {
            completion(Result<[User]>.success(users))
        }
        completion(Result<[User]>.failure(Err()))
    }
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
                
                presenter.didTapSearchButton(text: "query")
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるupdateUsersの実行を待つ")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                    exp.fulfill()
                })
                wait(for: [exp], timeout: 1)
                
                XCTAssertTrue(presenter.numberOfUsers == 1)
                XCTAssertTrue(spy.countOfInvokingUpdateUsers == 1)
            }
            XCTContext.runActivity(named: "ユーザー検索失敗時はView更新処理が呼ばれないこと") { _ in
                let spy = SearchUserPresenterOutputSpy()
                let stub = SearchUserModelInputStub(shouldSuccess: false)
                let presenter = SearchUserPresenter(view: spy, model: stub)
                
                presenter.didTapSearchButton(text: "query")
                
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
                
                presenter.didTapSearchButton(text: "query")
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるupdateUsersの実行を待つ")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                    exp.fulfill()
                })
                wait(for: [exp], timeout: 1)
                
                XCTAssertTrue(spy.countOfInvokingTransitionToUserDetail == 0)
                presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(spy.countOfInvokingTransitionToUserDetail == 1)
            }
            XCTContext.runActivity(named: "失敗時にユーザー詳細への遷移処理が呼ばれないこと") { _ in
                let spy = SearchUserPresenterOutputSpy()
                let stub = SearchUserModelInputStub(shouldSuccess: false)
                let presenter = SearchUserPresenter(view: spy, model: stub)
                
                presenter.didTapSearchButton(text: "query")
                
                XCTAssertTrue(spy.countOfInvokingTransitionToUserDetail == 0)
                presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(spy.countOfInvokingTransitionToUserDetail == 0)
            }
        }
    }
}
