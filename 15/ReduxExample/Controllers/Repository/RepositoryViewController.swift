import UIKit
import RxSwift
import RxCocoa
import IGListKit
import Redux

final class RepositoryViewController: UIViewController, HasWeakStateDisposeBag {
    typealias ThisState = RepositoryState
    weak var weakStateDisposeBag: RxSwift.DisposeBag? // For HasWeakStateDisposeBag
    let reduxStore: ReduxStoreType
    let state: Observable<ThisState>
    let input: RepositoryState.Input
    var didSetupConstraints = false

    lazy var dataSource: DataSource = .init(reduxStore, disposeBag: disposeBag)
    lazy var adapter: IGListKit.ListAdapter = .init(updater: IGListKit.ListAdapterUpdater(), viewController: self)
    lazy var loadingViewController: LoadingViewController = .init()
    lazy var networkErrorViewController: NetworkErrorViewController = .init()
    lazy var serverErrorViewController: ServerErrorViewController = .init()
    lazy var unknownErrorViewController: UnknownErrorViewController = .init()
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(
            width: view.bounds.size.width,
            height: UICollectionViewFlowLayout.automaticSize.height
        )
        return flowLayout
    }())

    init(
        reduxStore: ReduxStoreType,
        state: Observable<ThisState>,
        stateIdentifier: StateIdentifier,
        input: RepositoryState.Input,
        disposeBag: RxSwift.DisposeBag
    ) {
        self.reduxStore = reduxStore
        self.state = state
        self.input = input
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

        networkErrorViewController.retryButton.rx.tap
            .bind(to: Binder(self) { me, _ in me.request() })
            .disposed(by: disposeBag)

        request()

        view.setNeedsUpdateConstraints()
    }

    func request(_ connectionType: ConnectionType) {
        reduxStore.dispatch(
            ThisState.Action.requestAsyncCreator(
                connectionType: connectionType,
                owner: input.owner,
                repo: input.repo,
                disposeBag: disposeBag
            )
        )
    }

    func requestAuthenticated(_ connectionType: ConnectionType) {
        reduxStore.dispatch(
            ThisState.Action.requestAuthenticatedAsyncCreator(
                connectionType: connectionType,
                owner: input.owner,
                repo: input.repo,
                disposeBag: disposeBag
            )
        )
    }

    func requestReadme(_ connectionType: ConnectionType) {
        reduxStore.dispatch(
            ThisState.Action.requestReadmeAsyncCreator(
                connectionType: connectionType,
                owner: input.owner,
                repo: input.repo,
                disposeBag: disposeBag
            )
        )
    }

    func requestReadmeAuthenticated(_ connectionType: ConnectionType) {
        reduxStore.dispatch(
            ThisState.Action.requestReadmeAuthenticatedAsyncCreator(
                connectionType: connectionType,
                owner: input.owner,
                repo: input.repo,
                disposeBag: disposeBag
            )
        )
    }

    func request() {
        if reduxStore.state.authenticationState.isAuthenticated {
            requestAuthenticated(.initialRequest)
            requestReadmeAuthenticated(.initialRequest)
        } else {
            request(.initialRequest)
            requestReadme(.initialRequest)
        }
    }

    func applyState(_ state: ThisState) {
        loadingViewController.view.isShown = state.shouldShowLoading
        networkErrorViewController.view.isShown = state.shouldShowNetworkError
        serverErrorViewController.view.isShown = state.shouldShowServerError
        unknownErrorViewController.view.isShown = state.shouldShowUnknownError
    }

    override func updateViewConstraints() {
        if didSetupConstraints == false {
            constraintToSafeAreaLayoutGuideAnchorHelper(from: collectionView, to: view)
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}

extension RepositoryViewController {
    final class DataSource: AdapterDataSource {
        override func listAdapter(_ listAdapter: IGListKit.ListAdapter, sectionControllerFor object: Any) -> IGListKit.ListSectionController {
            switch object {
            case let o as DiffableWrap<TitleSectionController.Element>:
                return TitleSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<RepositorySectionController.Element>:
                return RepositorySectionController(o, reduxStore: reduxStore, disposeBag: disposeBag, selectable: false)
            case let o as DiffableWrap<PublicUserSectionController.Element>:
                return PublicUserSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<ReadmeSectionController.Element>:
                return ReadmeSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<LoadingSectionController.Element>:
                return LoadingSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<NetworkErrorSectionController.Element>:
                return NetworkErrorSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<UnknownErrorSectionController.Element>:
                return UnknownErrorSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            default:
                assertionFailureUnreachable()
                return SpaceBoxSectionController()
            }
        }
    }
}
