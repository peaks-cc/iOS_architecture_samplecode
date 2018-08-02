//: [Previous](@previous)

import GitHub
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let request = SearchUsersRequest(query: "marty", sort: nil, order: nil, page: nil, perPage: nil)
Session().send(request) { result in
    switch result {
    case let .success(response, pagination):
        print(response)
        print(pagination)
    case let .failure(error):
        break
    }
    PlaygroundPage.current.finishExecution()
}

//: [Next](@next)
