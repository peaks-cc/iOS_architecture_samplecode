import Foundation
import ReSwift
import RxSwift
import API
import GitHubAPI

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - State
///////////////////////////////////////////////s///////////////////////////////////////////
public struct UserRepositoriesState: ReSwift.StateType, HasDisposeBag, HasDataSourceElements {
    public typealias ThisState = UserRepositoriesState
    public typealias Response = API.Response<[GitHubAPI.Repo]>
    public let disposeBag: RxSwift.DisposeBag = .init() // for HasDisposeBag
    private var requestState: RequestState<Response> = .init()
    private var apiDomainError: APIDomainError? {
        return requestState.error
    }
    private var connectionTypeForShouldRequest: ConnectionType {
        return requestState.hasResponse ? .implicitlyReload : .initialRequest
    }
    private var shouldShowMoreRepository: Bool = false
    private var shouldShowAdvertising: Bool = true
    private var lastNoticeCount: Int = 0 // Use same notice count when tapped show all repository
    private var favoriteIds: [RepositoryId] = []
    public private(set) var dataSourceElements: DataSourceElements = .init() // For HasDataSourceElements
    public private(set) var shouldRequestTrigger: ShouldRequestTrigger?

    // Loading
    public var shouldShowLoading: Bool {
        return requestState.initialRequesting
    }
    public var shouldShowRefreshing: Bool {
        return requestState.refreshing
    }

    // Error
    public var shouldShowNetworkError: Bool {
        // Ignore refreshReload or implicitlyReload connectionType
        return (apiDomainError?.isNetworkError ?? false) &&
            [.initialRequest, .forceReload].contains(requestState.connectionType)
    }
    public var shouldShowServerError: Bool {
        // Ignore refreshReload or implicitlyReload connectionType
        return (apiDomainError?.isInternalServerError ?? false) &&
            [.initialRequest, .forceReload].contains(requestState.connectionType)
    }
    public var shouldShowUnknownError: Bool {
        return apiDomainError != nil &&
            apiDomainError?.isNetworkError != true &&
            apiDomainError?.isInternalServerError != true
    }
    public var shouldShowErrorNotificationTrigger: ErrorNotificationTrigger?
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
extension UserRepositoriesState {
    public enum Action: ReSwift.Action {
        case requestStart(connectionType: ConnectionType)
        case requestSuccess(response: Response)
        case requestError(error: APIDomainError)
        case showMoreRepository(isShowMore: Bool)
        case hideAdvertising

        public static func requestAsyncCreator(
            connectionType: ConnectionType,
            disposeBag: RxSwift.DisposeBag
        ) -> RequestAuthenticatedActionCreator {
            return { (_: AppState, store: DispatchingStoreType, accessToken: AccessToken) in
                store.dispatch(Action.requestStart(connectionType: connectionType))
                return ThunkAction(
                    GitHubAPI.DefaultAPI
                        .userReposGetSingle(accessToken: accessToken)
                        .map { Action.requestSuccess(response: $0) }
                        .mapError { Action.requestError(error: $0) },
                    disposeBag: disposeBag
                )
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Reducer
//////////////////////////////////////////////////////////////////////////////////////////
extension UserRepositoriesState {
    public static func reducer(action: ReSwift.Action, state: ThisState) -> ThisState {
        var state = state
        switch action {
        case let action as GlobalState.Action:
            switch action {
            case .changeAppTab(let appTab):
                if case .main = appTab, state.requestState.connecting == false {
                    state.shouldRequestTrigger = ShouldRequestTrigger(state.connectionTypeForShouldRequest)
                }
            case .changeApplicationState(let appState):
                if case .didBecomeActive = appState, state.requestState.connecting == false {
                    state.shouldRequestTrigger = ShouldRequestTrigger(state.connectionTypeForShouldRequest)
                }
            }
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

                if state.requestState.connectionType == .refreshReload {
                    // Reset showing more repository when refresh request
                    state.shouldShowMoreRepository = false
                    state.lastNoticeCount = Int.random(in: 0...notices.count)
                } else {
                    state.lastNoticeCount = 1
                }
                state.dataSourceElements = createDataSourceElements(response, state: state)
            case .requestError(let error):
                state.requestState = RequestState(requestState: state.requestState, error: error)

                if let networkError = error.networkError,
                    state.requestState.connectionType == .refreshReload {
                    state.shouldShowErrorNotificationTrigger = ErrorNotificationTrigger(
                        message: networkError.description
                    )
                }
            case .showMoreRepository(let isShowMore):
                state.shouldShowMoreRepository = isShowMore
                guard let response = state.requestState.response else { assertionFailureUnreachable(); return state }
                state.dataSourceElements = createDataSourceElements(response, state: state)
            case .hideAdvertising:
                state.shouldShowAdvertising = false
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
            shouldShowMoreRepository: state.shouldShowMoreRepository,
            shouldShowAdvertising: state.shouldShowAdvertising,
            noticeCount: state.lastNoticeCount,
            favoriteIds: state.favoriteIds
        )
    }

    static func createDataSourceElements(
        _ response: Response,
        shouldShowMoreRepository: Bool,
        shouldShowAdvertising: Bool,
        noticeCount: Int,
        favoriteIds: [RepositoryId]
    ) -> DataSourceElements {
        let ds = DataSourceElements(animated: true)
        ds.append(TitleElement("MainViewController"))
        ds.append(TitleElement("┗ UserRepositoriesViewController"))
        for i in 0..<noticeCount {
            ds.append(NoticeElement(notice: notices[i]))
        }
        ds.append(RepositoryHeaderElement())
        response.content.enumerated().forEach {
            if shouldShowAdvertising && $0.offset == 2 {
                ds.append(AdvertisingElement(ThisState.Action.hideAdvertising))
            }
            if shouldShowMoreRepository || $0.offset < 10 {
                let isFavorite = favoriteIds.contains($0.element.id)
                ds.append(RepositoryElement($0.element, isFavorite: isFavorite))
            }
        }
        if shouldShowMoreRepository == false {
            let isShowMore = shouldShowMoreRepository == false
            ds.append(ShowMoreRepositoryElement(.repositoryType(isShowMore: isShowMore)))
        }
        return ds
    }
}
