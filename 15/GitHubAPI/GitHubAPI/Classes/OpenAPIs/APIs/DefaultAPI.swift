//
// DefaultAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

open class DefaultAPI {
    /**

     - parameter owner: (path) Name of repository owner. 
     - parameter repo: (path) Name of repository. 
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func reposOwnerRepoGet(owner: String, repo: String, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, apiResponseQueue: DispatchQueue = GitHubAPIAPI.apiResponseQueue, completion: @escaping ((_ data: Repo?, _ error: Error?) -> Void)) {
        reposOwnerRepoGetWithRequestBuilder(owner: owner, repo: repo, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId).execute(apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     - GET /repos/{owner}/{repo}
     - Get repository.
     - parameter owner: (path) Name of repository owner. 
     - parameter repo: (path) Name of repository. 
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - returns: RequestBuilder<Repo> 
     */
    open class func reposOwnerRepoGetWithRequestBuilder(owner: String, repo: String, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil) -> RequestBuilder<Repo> {
        var path = "/repos/{owner}/{repo}"
        let ownerPreEscape = "\(APIHelper.mapValueToPathItem(owner))"
        let ownerPostEscape = ownerPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{owner}", with: ownerPostEscape, options: .literal, range: nil)
        let repoPreEscape = "\(APIHelper.mapValueToPathItem(repo))"
        let repoPostEscape = repoPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{repo}", with: repoPostEscape, options: .literal, range: nil)
        let URLString = GitHubAPIAPI.basePath + path
        let parameters: [String: Any]? = nil

        let url = URLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-GitHub-Media-Type": xGitHubMediaType?.encodeToJSON(),
            "Accept": accept?.encodeToJSON(),
            "X-RateLimit-Limit": xRateLimitLimit?.encodeToJSON(),
            "X-RateLimit-Remaining": xRateLimitRemaining?.encodeToJSON(),
            "X-RateLimit-Reset": xRateLimitReset?.encodeToJSON(),
            "X-GitHub-Request-Id": xGitHubRequestId?.encodeToJSON(),
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Repo>.Type = GitHubAPIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }

    /**

     - parameter owner: (path) Name of repository owner. 
     - parameter repo: (path) Name of repository. 
     - parameter ref: (query) The String name of the Commit/Branch/Tag. Defaults to master. (optional)
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func reposOwnerRepoReadmeGet(owner: String, repo: String, ref: String? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, apiResponseQueue: DispatchQueue = GitHubAPIAPI.apiResponseQueue, completion: @escaping ((_ data: Readme?, _ error: Error?) -> Void)) {
        reposOwnerRepoReadmeGetWithRequestBuilder(owner: owner, repo: repo, ref: ref, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId).execute(apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     - GET /repos/{owner}/{repo}/readme
     - Get the README. This method returns the preferred README for a repository. 
     - parameter owner: (path) Name of repository owner. 
     - parameter repo: (path) Name of repository. 
     - parameter ref: (query) The String name of the Commit/Branch/Tag. Defaults to master. (optional)
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - returns: RequestBuilder<Readme> 
     */
    open class func reposOwnerRepoReadmeGetWithRequestBuilder(owner: String, repo: String, ref: String? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil) -> RequestBuilder<Readme> {
        var path = "/repos/{owner}/{repo}/readme"
        let ownerPreEscape = "\(APIHelper.mapValueToPathItem(owner))"
        let ownerPostEscape = ownerPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{owner}", with: ownerPostEscape, options: .literal, range: nil)
        let repoPreEscape = "\(APIHelper.mapValueToPathItem(repo))"
        let repoPostEscape = repoPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{repo}", with: repoPostEscape, options: .literal, range: nil)
        let URLString = GitHubAPIAPI.basePath + path
        let parameters: [String: Any]? = nil

        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "ref": ref?.encodeToJSON(),
        ])

        let nillableHeaders: [String: Any?] = [
            "X-GitHub-Media-Type": xGitHubMediaType?.encodeToJSON(),
            "Accept": accept?.encodeToJSON(),
            "X-RateLimit-Limit": xRateLimitLimit?.encodeToJSON(),
            "X-RateLimit-Remaining": xRateLimitRemaining?.encodeToJSON(),
            "X-RateLimit-Reset": xRateLimitReset?.encodeToJSON(),
            "X-GitHub-Request-Id": xGitHubRequestId?.encodeToJSON(),
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Readme>.Type = GitHubAPIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }

    /**

     - parameter perPage: (query) The page limti. (optional)
     - parameter since: (query) The time should be passed in as UTC in the ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Example: \&quot;2012-10-09T23:39:01Z\&quot;.  (optional)
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func repositoriesGet(perPage: Int? = nil, since: String? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, apiResponseQueue: DispatchQueue = GitHubAPIAPI.apiResponseQueue, completion: @escaping ((_ data: [PublicRepo]?, _ error: Error?) -> Void)) {
        repositoriesGetWithRequestBuilder(perPage: perPage, since: since, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId).execute(apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     - GET /repositories
     - List all public repositories. This provides a dump of every public repository, in the order that they were created. Note: Pagination is powered exclusively by the since parameter. is the Link header to get the URL for the next page of repositories. 
     - parameter perPage: (query) The page limti. (optional)
     - parameter since: (query) The time should be passed in as UTC in the ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Example: \&quot;2012-10-09T23:39:01Z\&quot;.  (optional)
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - returns: RequestBuilder<[PublicRepo]> 
     */
    open class func repositoriesGetWithRequestBuilder(perPage: Int? = nil, since: String? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil) -> RequestBuilder<[PublicRepo]> {
        let path = "/repositories"
        let URLString = GitHubAPIAPI.basePath + path
        let parameters: [String: Any]? = nil

        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "per_page": perPage?.encodeToJSON(),
            "since": since?.encodeToJSON(),
        ])

        let nillableHeaders: [String: Any?] = [
            "X-GitHub-Media-Type": xGitHubMediaType?.encodeToJSON(),
            "Accept": accept?.encodeToJSON(),
            "X-RateLimit-Limit": xRateLimitLimit?.encodeToJSON(),
            "X-RateLimit-Remaining": xRateLimitRemaining?.encodeToJSON(),
            "X-RateLimit-Reset": xRateLimitReset?.encodeToJSON(),
            "X-GitHub-Request-Id": xGitHubRequestId?.encodeToJSON(),
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<[PublicRepo]>.Type = GitHubAPIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }

    /**

     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func userGet(xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, apiResponseQueue: DispatchQueue = GitHubAPIAPI.apiResponseQueue, completion: @escaping ((_ data: User?, _ error: Error?) -> Void)) {
        userGetWithRequestBuilder(xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId).execute(apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     - GET /user
     - Get the authenticated user.
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - returns: RequestBuilder<User> 
     */
    open class func userGetWithRequestBuilder(xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil) -> RequestBuilder<User> {
        let path = "/user"
        let URLString = GitHubAPIAPI.basePath + path
        let parameters: [String: Any]? = nil

        let url = URLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-GitHub-Media-Type": xGitHubMediaType?.encodeToJSON(),
            "Accept": accept?.encodeToJSON(),
            "X-RateLimit-Limit": xRateLimitLimit?.encodeToJSON(),
            "X-RateLimit-Remaining": xRateLimitRemaining?.encodeToJSON(),
            "X-RateLimit-Reset": xRateLimitReset?.encodeToJSON(),
            "X-GitHub-Request-Id": xGitHubRequestId?.encodeToJSON(),
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<User>.Type = GitHubAPIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }

    /**
     * enum for parameter type
     */
    public enum ModelType_userReposGet: String, CaseIterable {
        case all = "all"
        case _public = "public"
        case _private = "private"
        case forks = "forks"
        case sources = "sources"
        case member = "member"
    }

    /**

     - parameter type: (query)  (optional, default to .all)
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func userReposGet(type: ModelType_userReposGet? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, apiResponseQueue: DispatchQueue = GitHubAPIAPI.apiResponseQueue, completion: @escaping ((_ data: [Repo]?, _ error: Error?) -> Void)) {
        userReposGetWithRequestBuilder(type: type, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId).execute(apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     - GET /user/repos
     - List repositories for the authenticated user. Note that this does not include repositories owned by organizations which the user can access. You can lis user organizations and list organization repositories separately. 
     - parameter type: (query)  (optional, default to .all)
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - returns: RequestBuilder<[Repo]> 
     */
    open class func userReposGetWithRequestBuilder(type: ModelType_userReposGet? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil) -> RequestBuilder<[Repo]> {
        let path = "/user/repos"
        let URLString = GitHubAPIAPI.basePath + path
        let parameters: [String: Any]? = nil

        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "type": type?.encodeToJSON(),
        ])

        let nillableHeaders: [String: Any?] = [
            "X-GitHub-Media-Type": xGitHubMediaType?.encodeToJSON(),
            "Accept": accept?.encodeToJSON(),
            "X-RateLimit-Limit": xRateLimitLimit?.encodeToJSON(),
            "X-RateLimit-Remaining": xRateLimitRemaining?.encodeToJSON(),
            "X-RateLimit-Reset": xRateLimitReset?.encodeToJSON(),
            "X-GitHub-Request-Id": xGitHubRequestId?.encodeToJSON(),
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<[Repo]>.Type = GitHubAPIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }

    /**

     - parameter username: (path) Name of user. 
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersUsernameGet(username: String, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, apiResponseQueue: DispatchQueue = GitHubAPIAPI.apiResponseQueue, completion: @escaping ((_ data: PublicUser?, _ error: Error?) -> Void)) {
        usersUsernameGetWithRequestBuilder(username: username, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId).execute(apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     - GET /users/{username}
     - Get a single user.
     - parameter username: (path) Name of user. 
     - parameter xGitHubMediaType: (header) You can check the current version of media type in responses.  (optional)
     - parameter accept: (header) Is used to set specified media type. (optional)
     - parameter xRateLimitLimit: (header)  (optional)
     - parameter xRateLimitRemaining: (header)  (optional)
     - parameter xRateLimitReset: (header)  (optional)
     - parameter xGitHubRequestId: (header)  (optional)
     - returns: RequestBuilder<PublicUser> 
     */
    open class func usersUsernameGetWithRequestBuilder(username: String, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil) -> RequestBuilder<PublicUser> {
        var path = "/users/{username}"
        let usernamePreEscape = "\(APIHelper.mapValueToPathItem(username))"
        let usernamePostEscape = usernamePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{username}", with: usernamePostEscape, options: .literal, range: nil)
        let URLString = GitHubAPIAPI.basePath + path
        let parameters: [String: Any]? = nil

        let url = URLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-GitHub-Media-Type": xGitHubMediaType?.encodeToJSON(),
            "Accept": accept?.encodeToJSON(),
            "X-RateLimit-Limit": xRateLimitLimit?.encodeToJSON(),
            "X-RateLimit-Remaining": xRateLimitRemaining?.encodeToJSON(),
            "X-RateLimit-Reset": xRateLimitReset?.encodeToJSON(),
            "X-GitHub-Request-Id": xGitHubRequestId?.encodeToJSON(),
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<PublicUser>.Type = GitHubAPIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }

}
