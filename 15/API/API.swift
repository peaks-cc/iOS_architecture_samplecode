import Foundation
import RxSwift
import Alamofire
import SwiftyBeaver
import GitHubAPI

let logger = SwiftyBeaver.self

public struct Response<T: Codable> {
    public let content: T
    public let urlRequest: URLRequest
}

public struct NoContent: Codable {}

// MARK: - For AccessToken
public typealias AccessToken = String
extension RequestBuilder where T: Decodable {
    fileprivate func addAuthorizationHeader(_ accessToken: AccessToken) {
        _ = self.addHeader(name: "Authorization", value: "token \(accessToken)")
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - GitHubAPI.DefaultAPI
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
extension GitHubAPI.DefaultAPI {
    public class func publicReposGetSingle(perPage: Int) -> Single<Response<[GitHubAPI.PublicRepo]>> {
        let rb = repositoriesGetWithRequestBuilder(perPage: perPage)
        return requestAsSingle(requestBuilder: rb)
    }

    public class func userReposGetSingle(accessToken: AccessToken) -> Single<Response<[GitHubAPI.Repo]>> {
        let rb = userReposGetWithRequestBuilder()
        rb.addAuthorizationHeader(accessToken)
        return requestAsSingle(requestBuilder: rb)
    }

    public class func reposOwnerRepoGetSingle(owner: String, repo: String) -> Single<Response<GitHubAPI.Repo>> {
        let rb = reposOwnerRepoGetWithRequestBuilder(owner: owner, repo: repo)
        return requestAsSingle(requestBuilder: rb)
    }

    public class func reposOwnerRepoAuthenticatedGetSingle(accessToken: AccessToken, owner: String, repo: String) -> Single<Response<GitHubAPI.Repo>> {
        let rb = reposOwnerRepoGetWithRequestBuilder(owner: owner, repo: repo)
        rb.addAuthorizationHeader(accessToken)
        return requestAsSingle(requestBuilder: rb)
    }

    public class func userGetSingle(accessToken: AccessToken) -> Single<Response<User>> {
        let rb = userGetWithRequestBuilder()
        rb.addAuthorizationHeader(accessToken)
        return requestAsSingle(requestBuilder: rb)
    }

    public class func publicUserGetSingle(username: String) -> Single<Response<PublicUser>> {
        let rb = usersUsernameGetWithRequestBuilder(username: username)
        return requestAsSingle(requestBuilder: rb)
    }

    public class func reposOwnerRepoReadmeGetSingle(accessToken: AccessToken?, owner: String, repo: String) -> Single<Response<GitHubAPI.Readme>> {
        let rb = reposOwnerRepoReadmeGetWithRequestBuilder(owner: owner, repo: repo)
        if let accessToken = accessToken {
            rb.addAuthorizationHeader(accessToken)
        }
        return requestAsSingle(requestBuilder: rb)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Private Helper Methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Single<T> -------------------------------------------------------------------------------------------------
private func requestAsSingle<T: Decodable>(requestBuilder rb: RequestBuilder<T>) -> Single<Response<T>> {
    return RxSwift.Single.create { observer -> Disposable in
        guard let rb = rb as? AlamofireRequestBuilder<T>, let urlRequest = rb.makeDataRequest().request else {
            observer(.failure(APIDomainError.unreachable))
            return Disposables.create()
        }

        loggerInfo(urlRequest)
        rb.execute { (result: Swift.Result<GitHubAPI.Response<T>, Swift.Error>) -> Void in
            switch result {
            case let .success(response):
                if let body = response.body {
                    let response = Response(content: body, urlRequest: urlRequest)
                    observer(.success(response))
                } else {
                    observer(.failure(APIDomainError.unreachable))
                }
            case let .failure(error):
                loggerError(urlRequest, error: error)
                if let responseError = (error as? GitHubAPI.ErrorResponse)?.responseError {
                    if let networkError = responseError.networkError {
                        observer(.failure(APIDomainError.network(error: networkError)))
                    } else {
                        observer(.failure(APIDomainError.response(error: responseError)))
                    }
                } else {
                    observer(.failure(APIDomainError.unknownError(error: error)))
                }
            }
        }
        return Disposables.create()
    }
}

// MARK: - Single<NoContent> -----------------------------------------------------------------------------------------
private func requestAsSingleNoContent(requestBuilder rb: RequestBuilder<Void>) -> Single<Response<NoContent>> {
    return RxSwift.Single.create { observer -> Disposable in
        guard let rb = rb as? AlamofireRequestBuilder<Void>, let urlRequest = rb.makeDataRequest().request else {
            observer(.failure(APIDomainError.unreachable))
            return Disposables.create()
        }

        loggerInfo(urlRequest)
        rb.execute { (result: Swift.Result<GitHubAPI.Response<Void>, Swift.Error>) -> Void in
            switch result {
            case let .success(response):
                if response.statusCode == noContent { // For 204 NoContent
                    let response = Response(content: NoContent(), urlRequest: urlRequest)
                    observer(.success(response))
                } else {
                    observer(.failure(APIDomainError.unreachable))
                }
            case let .failure(error):
                loggerError(urlRequest, error: error)
                if let responseError = (error as? GitHubAPI.ErrorResponse)?.responseError {
                    if let networkError = responseError.networkError {
                        observer(.failure(APIDomainError.network(error: networkError)))
                    } else {
                        observer(.failure(APIDomainError.response(error: responseError)))
                    }
                } else {
                    observer(.failure(APIDomainError.unknownError(error: error)))
                }
            }
        }
        return Disposables.create()
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Logger
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
private func loggerInfo(_ urlRequest: URLRequest) {
    #if DEBUG
    logger.info("\n⚡️ \(urlRequest.cURLString) | jq .")
    #endif
}

private func loggerError(_ urlRequest: URLRequest, error: Error) {
    #if DEBUG
    logger.error("\(error)\n🚫 \(urlRequest.cURLString) | jq .")
    #endif
}
