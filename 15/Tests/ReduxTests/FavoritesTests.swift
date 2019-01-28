import XCTest
import ReSwift
import RxSwift
import Mockingjay
import MirrorDiffKit
import GitHubAPI
@testable import Redux
@testable import API

// swiftlint:disable force_try
class FavoritesTests: ReduxTestCase {
    var reduxStore: RxReduxStore!
    var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        reduxStore = createTestRxReduxStore()

        userDefaults = createTestUserDefaults()
        userDefaults.removePersistentDomain(forName: TestUserDefaultsName)
        userDefaults.synchronize()
    }

    func testInitilaIsEmpty() {
        do { // Check Prepare
            let array: [Favorite] = try! userDefaults.get(forKey: FavoritesState.key) ?? []
            XCTAssertEqual(0, array.count)
        }
        reduxStore.dispatch(
            FavoritesState.Action.loadFavoritesActionCreator()
        )
        do { // Check FavoriteState
            let ds = reduxStore.state.favoritesState.dataSourceElements
            XCTAssertEqual(1, ds.elements.count)
            XCTAssertTrue(reduxStore.state.favoritesState.shouldShowEmpty)
        }
    }

    func testFavoriteWithSaveUserDefaults() {
        let favorite = Favorite(id: 1,
                                owner: "owner",
                                name: "name",
                                descriptionForRepository: "description")
        do { // Check Prepare
            let array: [Favorite] = try! userDefaults.get(forKey: FavoritesState.key) ?? []
            XCTAssertEqual(0, array.count)
        }
        // Execute target
        reduxStore.dispatch(
            FavoritesState.Action.favoriteActionCreator(favorite: favorite)
        )
        do { // Check UserDefults
            let array: [Favorite] = try! userDefaults.get(forKey: FavoritesState.key) ?? []
            XCTAssertEqual(1, array.count)
            XCTAssertEqual(favorite, array.first)
        }
    }

    func testFavoriteWithApplyState() {
        let favorite = Favorite(id: 1,
                                owner: "owner",
                                name: "name",
                                descriptionForRepository: "description")
        // Execute target
        reduxStore.dispatch(
            FavoritesState.Action.favoriteActionCreator(favorite: favorite)
        )
        do { // Check FavoriteState
            let ds = reduxStore.state.favoritesState.dataSourceElements
            XCTAssertEqual(2, ds.elements.count)
            XCTAssertFalse(reduxStore.state.favoritesState.shouldShowEmpty)
            do {
                let e: TitleElement = ds.element(indexAt: 0)
                XCTAssertEqual("TitleElement-FavoritesViewController", e.identifier.description)
                XCTAssertEqual("FavoritesViewController", e.title)
            }
            do {
                let e: FavoriteElement = ds.element(indexAt: 1)
                XCTAssertEqual("FavoriteElement-1", e.identifier.description)
                XCTAssertEqual(favorite.id, e.id)
                XCTAssertEqual(favorite.name, e.name)
                XCTAssertEqual(Routing.Page.repository(
                                    (owner: favorite.owner, repo: favorite.name)
                               ),
                               e.routingPage)
            }
        }
    }

    func testUnFavoriteWithSaveUserDefaults() {
        let repositoryId: RepositoryId = 1
        do { // Check Prepare
            let favorite = Favorite(id: repositoryId,
                                owner: "owner",
                                name: "name",
                                descriptionForRepository: "description")
            reduxStore.dispatch(
                FavoritesState.Action.favoriteActionCreator(favorite: favorite)
            )
            let array: [Favorite] = try! userDefaults.get(forKey: FavoritesState.key) ?? []
            XCTAssertEqual(1, array.count)
        }
        // Execute target
        reduxStore.dispatch(
            FavoritesState.Action.unfavoriteActionCreator(repositoryId: repositoryId)
        )
        do { // Check UserDefults
            let array: [Favorite] = try! userDefaults.get(forKey: FavoritesState.key) ?? []
            XCTAssertEqual(0, array.count)
        }
    }

    func testUnFavoriteWithApplyState() {
        let repositoryId: RepositoryId = 1
        do { // Check Prepare
            let favorite = Favorite(id: repositoryId,
                                    owner: "owner",
                                    name: "name",
                                    descriptionForRepository: "description")
            reduxStore.dispatch(
                FavoritesState.Action.favoriteActionCreator(favorite: favorite)
            )
            let array: [Favorite] = try! userDefaults.get(forKey: FavoritesState.key) ?? []
            XCTAssertEqual(1, array.count)
        }
        // Execute target
        reduxStore.dispatch(
            FavoritesState.Action.unfavoriteActionCreator(repositoryId: repositoryId)
        )
        do { // Check FavoriteState
            let ds = reduxStore.state.favoritesState.dataSourceElements
            XCTAssertEqual(1, ds.elements.count)
            XCTAssertTrue(reduxStore.state.favoritesState.shouldShowEmpty)
        }
    }
}
// swiftlint:enable force_try
