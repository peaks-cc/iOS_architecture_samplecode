# GitHub

- SearchRepositoriesRequest
- SearchUsersRequest
- UserReposRequest

```swift
import GitHub

let request = SearchRepositoriesRequest(query: "flux", sort: nil, order: nil, page: nil, perPage: nil)
let session = Session()
session.request(request) { result in
  switch result {
    case let .success(response, pagination):
        break
    case let .failure(error):
        break
    }
}
```

- LoginViewController
- LoginViewControllerDelegate

```swift
let vc = LoginViewController(clientID: "", clientSecret: "", redirectURL: "")
vc.loginDelegate = self
```

```swift
extension ViewController: LoginViewControllerDelegate {
    func loginViewController(_ viewController: LoginViewController, didReceive accessToken: AccessToken) {
        // do something
    }

    func loginViewController(_ viewController: LoginViewController, didReceive error: Error) {
        // do something
    }
}
```