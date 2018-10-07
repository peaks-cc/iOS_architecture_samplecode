import Foundation
import ReSwift
import RxSwift
import API
import GitHubAPI

public struct Favorite: Codable, Equatable {
    public let id: RepositoryId
    public let owner: String
    public let name: String
    public let descriptionForRepository: String

    init(id: RepositoryId, owner: String, name: String, descriptionForRepository: String) {
        self.id = id
        self.owner = owner
        self.name = name
        self.descriptionForRepository = descriptionForRepository
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - State
//////////////////////////////////////////////////////////////////////////////////////////
public struct FavoritesState: ReSwift.StateType, HasDataSourceElements {
    public typealias ThisState = FavoritesState
    public static let key = "favorites"
    private var favorites: [Favorite] = []
    public var shouldShowEmpty: Bool { return favorites.isEmpty }
    public private(set) var dataSourceElements: DataSourceElements = .init() // For HasDataSourceElements
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
extension FavoritesState {
    public enum Action: ReSwift.Action {
        case loaded(favorites: [Favorite])

        public static func favoriteActionCreator(favorite: Favorite)
            -> UserDefaultsActionCreator {
                return { (_: AppState, userDefaults: UserDefaults) in
                    do {
                        var array: [Favorite] = try userDefaults.get(forKey: key) ?? []
                        let ids = array.map { $0.id }
                        if ids.contains(favorite.id) { return nil }
                        array.append(favorite)

                        try userDefaults.set(object: array, forKey: key)
                        userDefaults.synchronize()
                        return Action.loaded(favorites: array)
                    } catch {
                        assertionFailureUnreachable()
                        return nil
                    }
                }
        }

        public static func unfavoriteActionCreator(repositoryId: RepositoryId)
            -> UserDefaultsActionCreator {
                return { (_: AppState, userDefaults: UserDefaults) in
                    do {
                        var array: [Favorite] = try userDefaults.get(forKey: key) ?? []
                        array = array.filter { $0.id != repositoryId }
                        try userDefaults.set(object: array, forKey: key)
                        userDefaults.synchronize()
                        return Action.loaded(favorites: array)
                    } catch {
                        assertionFailureUnreachable()
                        return nil
                    }
                }
        }

        public static func loadFavoritesActionCreator()
            -> UserDefaultsActionCreator {
                return { (_: AppState, userDefaults: UserDefaults) in
                    do {
                        let array: [Favorite] = try userDefaults.get(forKey: key) ?? []
                        return Action.loaded(favorites: array)
                    } catch {
                        assertionFailureUnreachable()
                        return nil
                    }
                }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Reducer
//////////////////////////////////////////////////////////////////////////////////////////
extension FavoritesState {
    public static func reducer(action: ReSwift.Action, state: ThisState) -> ThisState {
        guard let action = action as? ThisState.Action else { return state }
        var state = state
        switch action {
        case .loaded(let favorites):
            state.favorites = favorites
            state.dataSourceElements = createDataSourceElements(favorites: favorites)
        }
        return state
    }

    private static func createDataSourceElements(favorites: [Favorite]) -> DataSourceElements {
        let ds = DataSourceElements(animated: true)
        ds.append(TitleElement("FavoritesViewController"))
        favorites.forEach {
            ds.append(FavoriteElement($0))
        }
        return ds
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Element
//////////////////////////////////////////////////////////////////////////////////////////
public struct FavoriteElement: Diffable {
    public let identifier: Identifier
    public let id: RepositoryId
    public let name: String
    public let descriptionForRepository: String
    public let routingPage: Routing.Page

    init(_ favorite: Favorite) {
        self.identifier = .init("\(String(describing: FavoriteElement.self))-\(favorite.id)")
        self.id = favorite.id
        self.name = favorite.name
        self.descriptionForRepository = favorite.descriptionForRepository
        self.routingPage = .repository((owner: favorite.owner, repo: favorite.name))
    }
}
