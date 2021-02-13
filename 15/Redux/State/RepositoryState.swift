import Foundation
import ReSwift
import RxSwift
import API
import GitHubAPI

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - State
///////////////////////////////////////////////s///////////////////////////////////////////
public struct RepositoryState: ReSwift.StateType, HasDisposeBag, HasDataSourceElements {
    public typealias ThisState = RepositoryState
    public typealias Response = (API.Response<GitHubAPI.Repo>, API.Response<GitHubAPI.PublicUser>)
    public typealias ResponseReadme = API.Response<GitHubAPI.Readme>
    public typealias Input = (owner: String, repo: String)
    public let input: Input
    public let disposeBag: RxSwift.DisposeBag = .init() // For HasDisposeBag
    private var requestState: RequestState<Response> = .init()
    private var requestReadmeState: RequestState<ResponseReadme> = .init()
    private var apiDomainError: APIDomainError? {
        return requestState.error
    }
    private var isRenderedMarkdown: Bool = false
    private var favoriteIds: [RepositoryId] = []
    public private(set) var dataSourceElements: DataSourceElements = .init() // For HasDataSourceElements

    // Loading
    public var shouldShowLoading: Bool {
        return requestState.initialRequesting
    }
    public var shouldShowRefreshing: Bool {
        return requestState.refreshing
    }

    // Error
    public var shouldShowNetworkError: Bool {
        return apiDomainError?.isNetworkError ?? false
    }
    public var shouldShowServerError: Bool {
        return apiDomainError?.isInternalServerError ?? false
    }
    public var shouldShowUnknownError: Bool {
        return apiDomainError != nil &&
            apiDomainError?.isNetworkError != true &&
            apiDomainError?.isInternalServerError != true
    }

    init(_ input: Input) {
        self.input = input
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
extension RepositoryState {
    public enum Action: ReSwift.Action {
        case requestStart(ConnectionType)
        case requestSuccess(Response)
        case requestError(APIDomainError)
        case requestReadmeStart(ConnectionType)
        case requestReadmeSuccess(ResponseReadme)
        case requestReadmeError(APIDomainError)
        case renderedMarkdown

        public static func requestAuthenticatedAsyncCreator(
            connectionType: ConnectionType,
            owner: String,
            repo: String,
            disposeBag: RxSwift.DisposeBag
            ) -> RequestAuthenticatedActionCreator {
            return { (_: AppState, store: DispatchingStoreType, accessToken: AccessToken) in
                store.dispatch(Action.requestStart(connectionType))
                return ThunkAction(
                    Single.zip(
                        GitHubAPI.DefaultAPI
                            .reposOwnerRepoAuthenticatedGetSingle(accessToken: accessToken, owner: owner, repo: repo),
                        GitHubAPI.DefaultAPI
                            .publicUserGetSingle(username: owner)
                        )
                        .map { Action.requestSuccess($0) }
                        .mapError { Action.requestError($0) },
                    disposeBag: disposeBag)
            }
        }

        public static func requestAsyncCreator(
            connectionType: ConnectionType,
            owner: String,
            repo: String,
            disposeBag: RxSwift.DisposeBag
        ) -> RequestActionCreator {
            return { (_: AppState, store: DispatchingStoreType) in
                store.dispatch(Action.requestStart(connectionType))
                return ThunkAction(
                    Single.zip(
                        GitHubAPI.DefaultAPI
                            .reposOwnerRepoGetSingle(owner: owner, repo: repo),
                        GitHubAPI.DefaultAPI
                            .publicUserGetSingle(username: owner)
                    )
                    .map { Action.requestSuccess($0) }
                    .mapError { Action.requestError($0) },
                    disposeBag: disposeBag)
            }
        }

        public static func requestReadmeAuthenticatedAsyncCreator(
            connectionType: ConnectionType,
            owner: String,
            repo: String,
            disposeBag: RxSwift.DisposeBag
        ) -> RequestAuthenticatedActionCreator {
            return { (_: AppState, store: DispatchingStoreType, accessToken: AccessToken) in
                store.dispatch(Action.requestReadmeStart(connectionType))
                return ThunkAction(
                    GitHubAPI.DefaultAPI
                        .reposOwnerRepoReadmeGetSingle(accessToken: accessToken, owner: owner, repo: repo)
                        .map { Action.requestReadmeSuccess($0) }
                        .mapError { Action.requestReadmeError($0) },
                    disposeBag: disposeBag)
            }
        }

        public static func requestReadmeAsyncCreator(
            connectionType: ConnectionType,
            owner: String,
            repo: String,
            disposeBag: RxSwift.DisposeBag
        ) -> RequestActionCreator {
            return { (_: AppState, store: DispatchingStoreType) in
                store.dispatch(Action.requestReadmeStart(connectionType))
                return ThunkAction(
                    GitHubAPI.DefaultAPI
                        .reposOwnerRepoReadmeGetSingle(accessToken: nil, owner: owner, repo: repo)
                        .map { Action.requestReadmeSuccess($0) }
                        .mapError { Action.requestReadmeError($0) },
                    disposeBag: disposeBag)
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Reducer
//////////////////////////////////////////////////////////////////////////////////////////
extension RepositoryState {
    public static func reducer(action: ReSwift.Action, state: ThisState) -> ThisState {
        var state = state
        switch action {
        case let action as FavoritesState.Action:
            switch action {
            case .loaded(let favorites):
                state.favoriteIds = favorites.map { $0.id }
                guard let response = state.requestState.response else { return state }
                state.dataSourceElements = createDataSourceElements(response, state: state)
            }
        case let action as ThisState.Action:
            switch action {
            case .requestStart(let connectionType):
                state.requestState = RequestState(requestState: state.requestState, connectionType: connectionType)
            case .requestSuccess(let response):
                state.requestState = RequestState(requestState: state.requestState, response: response)
                state.dataSourceElements = createDataSourceElements(response, state: state)
            case .requestError(let error):
                state.requestState = RequestState(requestState: state.requestState, error: error)
            case .requestReadmeStart(let connectionType):
                state.requestReadmeState = RequestState(requestState: state.requestReadmeState, connectionType: connectionType)
            case .requestReadmeSuccess(let responseReadme):
                state.requestReadmeState = RequestState(requestState: state.requestReadmeState, response: responseReadme)
                guard let response = state.requestState.response else { return state } // Wait main response
                state.dataSourceElements = createDataSourceElements(response, state: state)
            case .requestReadmeError(let error):
                state.requestReadmeState = RequestState(requestState: state.requestReadmeState, error: error)
                guard let response = state.requestState.response else { return state } // Wait main response
                state.dataSourceElements = createDataSourceElements(response, state: state)
            case .renderedMarkdown:
                state.isRenderedMarkdown = true
                guard let response = state.requestState.response else { assertionFailureUnreachable(); return state }
                state.dataSourceElements = createDataSourceElements(response, state: state)
            }
        default:
            break // Do not handle other action
        }
        return state
    }

    static func createDataSourceElements(_ response: Response, state: ThisState) -> DataSourceElements {
        return createDataSourceElements(response,
            requestReadmeState: state.requestReadmeState,
            isRenderedMarkdown: state.isRenderedMarkdown,
            favoriteIds: state.favoriteIds
        )
    }

    private static func createDataSourceElements(
        _ response: Response,
        requestReadmeState: RequestState<ResponseReadme>,
        isRenderedMarkdown: Bool,
        favoriteIds: [RepositoryId]
    ) -> DataSourceElements {
        let ds = DataSourceElements(animated: true)
        ds.append(TitleElement("RepositoryViewController"))
        // User
        ds.append(PublicUserElement(response.1.content))

        // Repository
        let isFavorite = favoriteIds.contains(response.0.content.id)
        ds.append(RepositoryElement(response.0.content, isFavorite: isFavorite))

        // Readme
        if let responseReadme = requestReadmeState.response {
            if let data = Data(base64Encoded: responseReadme.content.content, options: .ignoreUnknownCharacters),
                let readme = String(data: data, encoding: .utf8) {
                ds.append(ReadmeElement(readme, isRenderedMarkdown: isRenderedMarkdown))
            } else {
                ds.append(UnknownErrorElement())
            }
        } else if requestReadmeState.connecting {
            ds.append(LoadingElement())
        } else if requestReadmeState.error?.isNetworkError == true {
            ds.append(NetworkErrorElement())
        } else if requestReadmeState.error != nil {
            ds.append(UnknownErrorElement())
        }
        return ds
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Element
//////////////////////////////////////////////////////////////////////////////////////////
public struct PublicUserElement: Diffable {
    public let identifier: Identifier
    public let avatarUrl: URL?
    public let login: String

    init(_ user: GitHubAPI.PublicUser) {
        self.identifier = .init(user.id)
        self.avatarUrl = URL(string: user.avatarUrl ?? "")
        self.login = user.login
    }
}

public struct ReadmeElement: Diffable, Equatable {
    public let identifier: Identifier = .init(ReadmeElement.self)
    public let readme: String
    public let hash: Int
    public let isRenderedMarkdown: Bool

    init(_ readme: String, isRenderedMarkdown: Bool) {
        self.readme = readme
        self.hash = readme.hashValue
        self.isRenderedMarkdown = isRenderedMarkdown
    }

    public static func == (lhs: ReadmeElement, rhs: ReadmeElement) -> Bool {
        return lhs.hash == rhs.hash && lhs.isRenderedMarkdown == rhs.isRenderedMarkdown
    }
}

public struct LoadingElement: Diffable {
    public let identifier: Identifier = .init(LoadingElement.self)
}

public struct NetworkErrorElement: Diffable {
    public let identifier: Identifier = .init(NetworkErrorElement.self)
}

public struct UnknownErrorElement: Diffable {
    public let identifier: Identifier = .init(UnknownErrorElement.self)
}
