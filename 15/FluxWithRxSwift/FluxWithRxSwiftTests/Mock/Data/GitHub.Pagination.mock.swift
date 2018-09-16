//
//  GitHub.Pagination.mock.swift
//  FluxWithRxSwiftTests
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

extension GitHub.Pagination {
    static func mock() -> GitHub.Pagination {
        return GitHub.Pagination(next: nil, last: nil, first: nil, prev: nil)
    }
}
