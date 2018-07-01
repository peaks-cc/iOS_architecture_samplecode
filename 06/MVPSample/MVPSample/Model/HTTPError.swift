//
//  HTTPError.swift
//  MVPSample
//
//  Created by Kenji Tanaka on 2018/06/30.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case badRequest
    case unauthorized
    case notFound
    case serverError

    init(code: Int) {
        switch code {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 404:
            self = .notFound
        case 500:
            self = .serverError
        default:
            fatalError("Unknown HTTPStatus.")
        }
    }
}
