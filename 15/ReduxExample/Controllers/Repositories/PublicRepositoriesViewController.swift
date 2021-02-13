import UIKit
import RxSwift
import RxCocoa
import IGListKit
import Redux

final class PublicRepositoriesViewController: UIViewController, HasWeakStateDisposeBag {
    typealias ThisState = PublicRepositoriesState
    weak var weakStateDisposeBag: RxSwift.DisposeBag? // For HasWeakStateDisposeBag
    let reduxStore: ReduxStoreType
    let state: Observable<ThisState>
    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var didSetupConstraints = false

    lazy var dataSource: DataSource = .init(reduxStore, disposeBag: disposeBag)
    lazy var adapter: IGListKit.ListAdapter = .init(updater: IGListKit.ListAdapterUpdater(), viewController: self)
    lazy var loadingViewController: LoadingViewController = .init()
    lazy var networkErrorViewController: NetworkErrorViewController = .init()
    lazy var serverErrorViewController: ServerErrorViewController = .init()
    lazy var unknownErrorViewController: UnknownErrorViewController = .init()
    lazy var refreshControl: UIRefreshControl = .init()

    init(reduxStore: ReduxStoreType, state: Observable<ThisState>, disposeBag: RxSwift.DisposeBag) {
        self.reduxStore = reduxStore
        self.state = state
        self.weakStateDisposeBag = disposeBag
        super.init(nibName: nil, bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) hasb not been implemented")
    }

    deinit {
        reduxStore.dispatch(DisposeAction(disposeBag))
        deinitLog()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1.0)
        collectionView.refreshControl = refreshControl

        addChildHelper(networkErrorViewController)
        addChildHelper(loadingViewController)
        addChildHelper(serverErrorViewController)
        addChildHelper(unknownErrorViewController)

        adapter.collectionView = collectionView
        adapter.rx.setDataSource(dataSource).disposed(by: disposeBag)

        state
            .bind(to: Binder(self) { $0.applyState($1) })
            .disposed(by: disposeBag)
        state
            .map { $0.dataSourceElements }
            .bind(to: adapter.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        state
            .map { $0.shouldShowRefreshing }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        state
            .compactMap { $0.shouldRequestTrigger }
            .distinctUntilChanged()
            .bind(to: Binder(self) { $0.request($1.connectionType) })
            .disposed(by: disposeBag)
        state
            .compactMap { $0.shouldShowErrorNotificationTrigger }
            .distinctUntilChanged()
            .bind(to: Binder(self) { $0.showErrorNotification($1) })
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: Binder(self) { me, _ in me.refreshReload() })
            .disposed(by: disposeBag)

        networkErrorViewController.retryButton.rx.tap
            .bind(to: Binder(self) { me, _ in me.request(.initialRequest) })
            .disposed(by: disposeBag)

        request(.initialRequest)
        reduxStore.dispatch(FavoritesState.Action.loadFavoritesActionCreator())

        view.setNeedsUpdateConstraints()
    }

    func request(_ connectionType: ConnectionType) {
        reduxStore.dispatch(
            ThisState.Action.requestAsyncCreator(
                connectionType: connectionType,
                disposeBag: disposeBag
            )
        )
    }

    func refreshReload() {
        reduxStore.dispatch(
            ThisState.Action.requestAsyncCreator(
                connectionType: .refreshReload,
                disposeBag: disposeBag
            )
        )
    }

    func applyState(_ state: ThisState) {
        loadingViewController.view.isShown = state.shouldShowLoading
        networkErrorViewController.view.isShown = state.shouldShowNetworkError
        serverErrorViewController.view.isShown = state.shouldShowServerError
        unknownErrorViewController.view.isShown = state.shouldShowUnknownError
    }

    func showErrorNotification(_ trigger: ErrorNotificationTrigger) {
        errorNotificationViewController.show(with: trigger.message) // UIViewController+Ex
    }

    override func updateViewConstraints() {
        if didSetupConstraints == false {
            constraintToSafeAreaLayoutGuideAnchorHelper(from: collectionView, to: view)
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - DataSource
//////////////////////////////////////////////////////////////////////////////////////////
extension PublicRepositoriesViewController {
    final class DataSource: AdapterDataSource {
        override func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
            switch object {
            case let o as DiffableWrap<TitleSectionController.Element>:
                return TitleSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<NoticeSectionController.Element>:
                return NoticeSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<RepositoryHeaderSectionController.Element>:
                return RepositoryHeaderSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<PublicRepositorySectionController.Element>:
                return PublicRepositorySectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<AdvertisingSectionController.Element>:
                return AdvertisingSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<ShowMoreRepositorySectionController.Element>:
                return ShowMoreRepositorySectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            default:
                assertionFailureUnreachable(); return SpaceBoxSectionController()
            }
        }
    }
}
