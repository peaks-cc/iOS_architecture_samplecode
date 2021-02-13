# DefaultAPI

All URIs are relative to *https://api.github.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reposOwnerRepoGet**](DefaultAPI.md#reposownerrepoget) | **GET** /repos/{owner}/{repo} | 
[**reposOwnerRepoReadmeGet**](DefaultAPI.md#reposownerreporeadmeget) | **GET** /repos/{owner}/{repo}/readme | 
[**repositoriesGet**](DefaultAPI.md#repositoriesget) | **GET** /repositories | 
[**userGet**](DefaultAPI.md#userget) | **GET** /user | 
[**userReposGet**](DefaultAPI.md#userreposget) | **GET** /user/repos | 
[**usersUsernameGet**](DefaultAPI.md#usersusernameget) | **GET** /users/{username} | 


# **reposOwnerRepoGet**
```swift
    open class func reposOwnerRepoGet(owner: String, repo: String, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, completion: @escaping (_ data: Repo?, _ error: Error?) -> Void)
```



Get repository.

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import GitHubAPI

let owner = "owner_example" // String | Name of repository owner.
let repo = "repo_example" // String | Name of repository.
let xGitHubMediaType = "xGitHubMediaType_example" // String | You can check the current version of media type in responses.  (optional)
let accept = "accept_example" // String | Is used to set specified media type. (optional)
let xRateLimitLimit = 987 // Int |  (optional)
let xRateLimitRemaining = 987 // Int |  (optional)
let xRateLimitReset = 987 // Int |  (optional)
let xGitHubRequestId = 987 // Int |  (optional)

DefaultAPI.reposOwnerRepoGet(owner: owner, repo: repo, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **owner** | **String** | Name of repository owner. | 
 **repo** | **String** | Name of repository. | 
 **xGitHubMediaType** | **String** | You can check the current version of media type in responses.  | [optional] 
 **accept** | **String** | Is used to set specified media type. | [optional] 
 **xRateLimitLimit** | **Int** |  | [optional] 
 **xRateLimitRemaining** | **Int** |  | [optional] 
 **xRateLimitReset** | **Int** |  | [optional] 
 **xGitHubRequestId** | **Int** |  | [optional] 

### Return type

[**Repo**](Repo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reposOwnerRepoReadmeGet**
```swift
    open class func reposOwnerRepoReadmeGet(owner: String, repo: String, ref: String? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, completion: @escaping (_ data: Readme?, _ error: Error?) -> Void)
```



Get the README. This method returns the preferred README for a repository. 

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import GitHubAPI

let owner = "owner_example" // String | Name of repository owner.
let repo = "repo_example" // String | Name of repository.
let ref = "ref_example" // String | The String name of the Commit/Branch/Tag. Defaults to master. (optional)
let xGitHubMediaType = "xGitHubMediaType_example" // String | You can check the current version of media type in responses.  (optional)
let accept = "accept_example" // String | Is used to set specified media type. (optional)
let xRateLimitLimit = 987 // Int |  (optional)
let xRateLimitRemaining = 987 // Int |  (optional)
let xRateLimitReset = 987 // Int |  (optional)
let xGitHubRequestId = 987 // Int |  (optional)

DefaultAPI.reposOwnerRepoReadmeGet(owner: owner, repo: repo, ref: ref, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **owner** | **String** | Name of repository owner. | 
 **repo** | **String** | Name of repository. | 
 **ref** | **String** | The String name of the Commit/Branch/Tag. Defaults to master. | [optional] 
 **xGitHubMediaType** | **String** | You can check the current version of media type in responses.  | [optional] 
 **accept** | **String** | Is used to set specified media type. | [optional] 
 **xRateLimitLimit** | **Int** |  | [optional] 
 **xRateLimitRemaining** | **Int** |  | [optional] 
 **xRateLimitReset** | **Int** |  | [optional] 
 **xGitHubRequestId** | **Int** |  | [optional] 

### Return type

[**Readme**](Readme.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **repositoriesGet**
```swift
    open class func repositoriesGet(perPage: Int? = nil, since: String? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, completion: @escaping (_ data: [PublicRepo]?, _ error: Error?) -> Void)
```



List all public repositories. This provides a dump of every public repository, in the order that they were created. Note: Pagination is powered exclusively by the since parameter. is the Link header to get the URL for the next page of repositories. 

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import GitHubAPI

let perPage = 987 // Int | The page limti. (optional)
let since = "since_example" // String | The time should be passed in as UTC in the ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Example: \"2012-10-09T23:39:01Z\".  (optional)
let xGitHubMediaType = "xGitHubMediaType_example" // String | You can check the current version of media type in responses.  (optional)
let accept = "accept_example" // String | Is used to set specified media type. (optional)
let xRateLimitLimit = 987 // Int |  (optional)
let xRateLimitRemaining = 987 // Int |  (optional)
let xRateLimitReset = 987 // Int |  (optional)
let xGitHubRequestId = 987 // Int |  (optional)

DefaultAPI.repositoriesGet(perPage: perPage, since: since, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **perPage** | **Int** | The page limti. | [optional] 
 **since** | **String** | The time should be passed in as UTC in the ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Example: \&quot;2012-10-09T23:39:01Z\&quot;.  | [optional] 
 **xGitHubMediaType** | **String** | You can check the current version of media type in responses.  | [optional] 
 **accept** | **String** | Is used to set specified media type. | [optional] 
 **xRateLimitLimit** | **Int** |  | [optional] 
 **xRateLimitRemaining** | **Int** |  | [optional] 
 **xRateLimitReset** | **Int** |  | [optional] 
 **xGitHubRequestId** | **Int** |  | [optional] 

### Return type

[**[PublicRepo]**](PublicRepo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userGet**
```swift
    open class func userGet(xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, completion: @escaping (_ data: User?, _ error: Error?) -> Void)
```



Get the authenticated user.

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import GitHubAPI

let xGitHubMediaType = "xGitHubMediaType_example" // String | You can check the current version of media type in responses.  (optional)
let accept = "accept_example" // String | Is used to set specified media type. (optional)
let xRateLimitLimit = 987 // Int |  (optional)
let xRateLimitRemaining = 987 // Int |  (optional)
let xRateLimitReset = 987 // Int |  (optional)
let xGitHubRequestId = 987 // Int |  (optional)

DefaultAPI.userGet(xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xGitHubMediaType** | **String** | You can check the current version of media type in responses.  | [optional] 
 **accept** | **String** | Is used to set specified media type. | [optional] 
 **xRateLimitLimit** | **Int** |  | [optional] 
 **xRateLimitRemaining** | **Int** |  | [optional] 
 **xRateLimitReset** | **Int** |  | [optional] 
 **xGitHubRequestId** | **Int** |  | [optional] 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userReposGet**
```swift
    open class func userReposGet(type: ModelType_userReposGet? = nil, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, completion: @escaping (_ data: [Repo]?, _ error: Error?) -> Void)
```



List repositories for the authenticated user. Note that this does not include repositories owned by organizations which the user can access. You can lis user organizations and list organization repositories separately. 

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import GitHubAPI

let type = "type_example" // String |  (optional) (default to .all)
let xGitHubMediaType = "xGitHubMediaType_example" // String | You can check the current version of media type in responses.  (optional)
let accept = "accept_example" // String | Is used to set specified media type. (optional)
let xRateLimitLimit = 987 // Int |  (optional)
let xRateLimitRemaining = 987 // Int |  (optional)
let xRateLimitReset = 987 // Int |  (optional)
let xGitHubRequestId = 987 // Int |  (optional)

DefaultAPI.userReposGet(type: type, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String** |  | [optional] [default to .all]
 **xGitHubMediaType** | **String** | You can check the current version of media type in responses.  | [optional] 
 **accept** | **String** | Is used to set specified media type. | [optional] 
 **xRateLimitLimit** | **Int** |  | [optional] 
 **xRateLimitRemaining** | **Int** |  | [optional] 
 **xRateLimitReset** | **Int** |  | [optional] 
 **xGitHubRequestId** | **Int** |  | [optional] 

### Return type

[**[Repo]**](Repo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersUsernameGet**
```swift
    open class func usersUsernameGet(username: String, xGitHubMediaType: String? = nil, accept: String? = nil, xRateLimitLimit: Int? = nil, xRateLimitRemaining: Int? = nil, xRateLimitReset: Int? = nil, xGitHubRequestId: Int? = nil, completion: @escaping (_ data: PublicUser?, _ error: Error?) -> Void)
```



Get a single user.

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import GitHubAPI

let username = "username_example" // String | Name of user.
let xGitHubMediaType = "xGitHubMediaType_example" // String | You can check the current version of media type in responses.  (optional)
let accept = "accept_example" // String | Is used to set specified media type. (optional)
let xRateLimitLimit = 987 // Int |  (optional)
let xRateLimitRemaining = 987 // Int |  (optional)
let xRateLimitReset = 987 // Int |  (optional)
let xGitHubRequestId = 987 // Int |  (optional)

DefaultAPI.usersUsernameGet(username: username, xGitHubMediaType: xGitHubMediaType, accept: accept, xRateLimitLimit: xRateLimitLimit, xRateLimitRemaining: xRateLimitRemaining, xRateLimitReset: xRateLimitReset, xGitHubRequestId: xGitHubRequestId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **String** | Name of user. | 
 **xGitHubMediaType** | **String** | You can check the current version of media type in responses.  | [optional] 
 **accept** | **String** | Is used to set specified media type. | [optional] 
 **xRateLimitLimit** | **Int** |  | [optional] 
 **xRateLimitRemaining** | **Int** |  | [optional] 
 **xRateLimitReset** | **Int** |  | [optional] 
 **xGitHubRequestId** | **Int** |  | [optional] 

### Return type

[**PublicUser**](PublicUser.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

