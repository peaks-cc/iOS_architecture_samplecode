import UIKit
import Redux
import RxSwift
import RxCocoa
import IGListKit

final class FavoritesViewController: UIViewController, HasWeakStateDisposeBag {
    typealias ThisState = FavoritesState
    weak var weakStateDisposeBag: RxSwift.DisposeBag? // For HasWeakStateDisposeBag
    let reduxStore: ReduxStoreType
    let state: Observable<ThisState>
    var didSetupConstraints = false

    lazy var dataSource: DataSource = .init(reduxStore, disposeBag: disposeBag)
    lazy var adapter: IGListKit.ListAdapter = .init(updater: IGListKit.ListAdapterUpdater(), viewController: self)
    lazy var emptyViewController: EmptyViewController = .init()
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

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
        deinitLog()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1.0)
        addChildHelper(emptyViewController)
        emptyViewController.emptyLabel.text = "Favorite is empty"

        adapter.collectionView = collectionView
        adapter.rx.setDataSource(dataSource).disposed(by: disposeBag)

        state
            .map { $0.dataSourceElements }
            .bind(to: adapter.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        state
            .map { $0.shouldShowEmpty }
            .bind(to: Binder(self) { $0.emptyViewController.view.isShown = $1 })
            .disposed(by: disposeBag)

        reduxStore.dispatch(FavoritesState.Action.loadFavoritesActionCreator())

        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if didSetupConstraints == false {
            constraintToSafeAreaLayoutGuideAnchorHelper(from: collectionView, to: view)
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}

extension FavoritesViewController {
    final class DataSource: AdapterDataSource {
        override func listAdapter(_ listAdapter: IGListKit.ListAdapter, sectionControllerFor object: Any) -> IGListKit.ListSectionController {
            switch object {
            case let o as DiffableWrap<TitleSectionController.Element>:
                return TitleSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<FavoriteSectionController.Element>:
                return FavoriteSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            default:
                assertionFailureUnreachable()
                return SpaceBoxSectionController()
            }
        }
    }
}
