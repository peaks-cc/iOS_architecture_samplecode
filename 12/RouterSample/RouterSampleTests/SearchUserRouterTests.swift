//
//  SearchUserRouterTests.swift
//  RouterSampleTests
//
//  Created by Kenji Tanaka on 2018/09/23.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import XCTest
@testable import RouterSample

class SearchUserRouterTests: XCTestCase {
    func testTransitionToUserDetail() {
        var spyView: SpySearchUserView
        var router: SearchUserRouter

        spyView = SpySearchUserView()
        router = SearchUserRouter(view: spyView)
        router.transitionToUserDetail(userName: "userName")
        XCTAssertTrue(spyView.viewController is UserDetailViewController)

        spyView = SpySearchUserView()
        router = SearchUserRouter(view: spyView)
        router.transitionToUserDetail(userName: "ktanaka117")
        XCTAssertTrue(spyView.viewController is KTanakaViewController)
    }
}
