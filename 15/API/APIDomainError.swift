import Foundation
import Alamofire
import GitHubAPI

// swiftlint:disable identifier_name
let Unreachable = "UnreachableCode"
// swiftlint:enable identifier_name

extension GitHubAPI.ErrorResponse {
    public var responseError: ResponseError? {
        if case .error(let statusCode, let data, _, let error) = self {
            return ResponseError(statusCode: statusCode, data: data, error: error)
        }
        return nil
    }
}

public enum APIDomainError: Error, Equatable {
    public static func == (lhs: APIDomainError, rhs: APIDomainError) -> Bool {
        switch (lhs, rhs) {
        case (.response(let errorLhs), .response(let errorRhs)): return errorLhs == errorRhs
        case (.network(let errorLhs), .network(let errorRhs)): return errorLhs == errorRhs
        case (.unknown(let errorLhs), .unknown(let errorRhs)): return errorLhs == errorRhs
        case (.unreachable, .unreachable): return true
        default: return false
        }
    }
    case response(error: ResponseError)
    case network(error: NetworkError)
    case unknown(error: UnknownError)
    case unreachable

    public enum HandleError: Error {
        case networkError
        case internalServerError
        case serviceUnavailable
        case unauthorized
        case gatewayTimeout
        case badRequest
        case unknownError
    }

    public var handleError: HandleError {
        if networkError != nil {
            return .networkError
        }
        if responseError?.statusCode == internalServerError {
            return .internalServerError
        }
        if responseError?.statusCode == serviceUnavailable {
            return .serviceUnavailable
        }
        if responseError?.statusCode == unauthorized {
            return .unauthorized
        }
        if responseError?.statusCode == gatewayTimeout {
            return .gatewayTimeout
        }
        if responseError?.statusCode == badRequest {
            return .badRequest
        }
        return .unknownError
    }
}

extension APIDomainError {
    public var isNetworkError: Bool {
        return handleError == .networkError
    }
    public var isInternalServerError: Bool {
        return handleError == .internalServerError
    }
    public var isServiceUnavailable: Bool {
        return handleError == .serviceUnavailable
    }
    public var isUnauthorized: Bool {
        return handleError == .unauthorized
    }
    public var isGatewayTimeout: Bool {
        return handleError == .gatewayTimeout
    }
    public var isBadRequest: Bool {
        return handleError == .badRequest
    }
}

extension APIDomainError {
    public var responseError: ResponseError? {
        if case .response(let error) = self {
            return error
        } else {
            return nil
        }
    }
    public var networkError: NetworkError? {
        if case .network(let error) = self {
            return error
        } else {
            return nil
        }
    }
    public var unknownError: UnknownError? {
        if case .unknown(let error) = self {
            return error
        } else {
            return nil
        }
    }
}

extension APIDomainError {
    internal static var unknownError: APIDomainError {
        return APIDomainError.unknown(error: UnknownError())
    }
    internal static func unknownError(error: Error) -> APIDomainError {
        return APIDomainError.unknown(error: UnknownError(error))
    }
    internal static func responseError(statusCode: Int) -> APIDomainError {
        return APIDomainError.response(error: ResponseError(statusCode: statusCode, data: nil, error: UnknownError()))
    }
    internal static var networkError: APIDomainError {
        return APIDomainError.network(error: NetworkError(message: "Could not connect to the server."))
    }
    internal static func serverError() -> APIDomainError {
        return responseError(statusCode: internalServerError)
    }
}

public struct ResponseError: Error, Equatable {
    public static func == (lhs: ResponseError, rhs: ResponseError) -> Bool {
        if lhs.statusCode == badRequest && rhs.statusCode == badRequest {
            return lhs.data == rhs.data
        } else {
            return lhs.statusCode == rhs.statusCode
        }
    }
    public let statusCode: Int
    public let data: Data?
    public let error: Error

    public var networkError: NetworkError? {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return NetworkError(nsError)
        } else if let afError = error as? Alamofire.AFError {
            switch afError {
            case Alamofire.AFError.responseValidationFailed(let reason):
                switch reason {
                case .unacceptableContentType:
                    return NetworkError(message: "Unacceptable server.", code: -9999)
                default: break
                }
            default: break
            }
        }
        return nil
    }

    internal init(statusCode: Int, data: Data?, error: Error) {
        self.statusCode = statusCode
        self.data = data
        self.error = error
    }

    public func decodeBadRequest<T>(_ type: T.Type) -> Swift.Result<T, Error> where T: Decodable {
        guard statusCode == badRequest else { return .failure(APIDomainError.unknownError) }
        guard let data = data else { return .failure(APIDomainError.unknownError) }
        return GitHubAPI.CodableHelper.decode(type, from: data)
    }
}

public struct NetworkError: Error, Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        if lhs.identifier == rhs.identifier { return true }
        return lhs.code == rhs.code
    }
    public let message: String
    public let identifier = UUID().uuidString
    public let code: Int
    public let nsError: NSError?

    internal init(_ nsError: NSError) {
        self.message = nsError.localizedDescription
        self.code = nsError.code
        self.nsError = nsError
    }

    internal init(message: String = "", code: Int = -1) {
        self.message = message
        self.code = code
        self.nsError = nil
    }
}

public struct UnknownError: Error, Equatable {
    public static func == (lhs: UnknownError, rhs: UnknownError) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    public let identifier = UUID().uuidString
    public let error: Error?

    internal init(_ error: Error? = nil) {
        self.error = error
    }
}

private func createMessage(message: String, code: Int) -> String {
    #if DEBUG
    return "\(message) (\(code))"
    #else
    return message
    #endif
}

extension NetworkError: CustomStringConvertible {
    public var description: String {
        return createMessage(message: message, code: code)
    }
}

extension UnknownError: CustomStringConvertible {
    public var description: String {
        return createMessage(message: "System error has occurred.", code: -1)
    }
}

extension ResponseError: CustomStringConvertible {
    public var description: String {
        if statusCode == internalServerError {
            return createMessage(message: "Internal server error has occurred.", code: statusCode)
        } else if statusCode == unauthorized {
            // Does not show to a user.
            return createMessage(message: "Unauthenticated", code: statusCode)
        } else if statusCode == notFound {
            // Does not show to a user.
            return createMessage(message: "NotFound", code: statusCode)
        } else if statusCode == serviceUnavailable {
            // Does not show to a user.
            return createMessage(message: "UnderMaintenance", code: statusCode)
        } else if statusCode == gatewayTimeout {
            // Does not show to a user.
            return createMessage(message: "GatewayTimeout", code: statusCode)
        } else if let afError = error as? Alamofire.AFError {
            switch afError {
            case Alamofire.AFError.responseValidationFailed:
                // JSON parse failed.
                return createMessage(message: "System error has occurred.", code: 991001)
            default:
                return createMessage(message: "System error has occurred.", code: 991002)
            }
        } else {
            return createMessage(message: "System error has occurred.", code: 991003)
        }
    }
}
