//
//  GitHub.Pagination.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/08/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

extension GitHub {
    struct Pagination {
        var next: Int?
        var last: Int?
        var first: Int?
        var prev: Int?
    }
}

extension GitHub.Pagination {
    private static let regex = try! NSRegularExpression(pattern: ".*<https://api.github.com/.*page=(\\d+).*>; rel=\"(.*)\"", options: [])

    init(link: String) {
        let values = link.split(separator: ",")

        self = values.reduce(GitHub.Pagination(next: nil, last: nil, first: nil, prev: nil)) { pagination, value in
            let string = String(value)
            let results = GitHub.Pagination.regex.matches(in: string,
                                                          options: [],
                                                          range: NSRange(location: 0, length: (string as NSString).length))

            let values = results.compactMap { result -> (Int, String)? in
                let values = (0..<result.numberOfRanges).reduce((nil, nil)) { values, index -> (Int?, String?) in
                    if index == 0 {
                        return values
                    }
                    let range = result.range(at: index)
                    let str = (string as NSString).substring(with: range)

                    if index == 1, let page = Int(str) {
                        return (page, values.1)
                    } else if index == 2 {
                        return (values.0, str)
                    } else {
                        return values
                    }
                }

                if case let (page?, name?) = values {
                    return (page, name)
                } else {
                    return nil
                }
            }

            return values.reduce(pagination) { pagination, value in
                var newPagination = pagination
                switch value.1 {
                case "next":
                    newPagination.next = value.0
                case "last":
                    newPagination.last = value.0
                case "first":
                    newPagination.first = value.0
                case "prev":
                    newPagination.prev = value.0
                default:
                    break
                }
                return newPagination
            }
        }
    }
}
