import UIKit
import RxSwift
import RxCocoa
import IGListKit
import ReSwift
import Redux

#if DEBUG
class DebugIGListKitCatalogViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let reduxStore: RxReduxStore
    let disposeBag = DisposeBag()

    lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    lazy var dataSource = DataSource(self.reduxStore, disposeBag: self.disposeBag)
    lazy var dataSourceElementsBehavior: BehaviorRelay<DataSourceElements> =
        .init(value: dataSource.dataSourceElements)
    var didSetupConstraints = false

    init(reduxStore: RxReduxStore) {
        self.reduxStore = reduxStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Debug for IGListKit UI catalog"
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white

        dataSource.dataSourceElements = createDebugCatalogDataSourceElements()

        adapter.collectionView = collectionView
        adapter.rx
            .setDataSource(dataSource)
            .disposed(by: disposeBag)

        dataSourceElementsBehavior
            .bind(to: adapter.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

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

extension DebugIGListKitCatalogViewController {
    final class DataSource: AdapterDataSource {
        override func listAdapter(_ listAdapter: IGListKit.ListAdapter, sectionControllerFor object: Any) -> IGListKit.ListSectionController {
            switch object {
            case let o as DiffableWrap<TitleSectionController.Element>:
                return TitleSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<NoticeSectionController.Element>:
                return NoticeSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<RepositoryHeaderSectionController.Element>:
                return RepositoryHeaderSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<RepositorySectionController.Element>:
                return RepositorySectionController(o, reduxStore: reduxStore, disposeBag: disposeBag, selectable: false)
            case let o as DiffableWrap<PublicRepositorySectionController.Element>:
                return PublicRepositorySectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<AdvertisingSectionController.Element>:
                return AdvertisingSectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
            case let o as DiffableWrap<ShowMoreRepositorySectionController.Element>:
                return ShowMoreRepositorySectionController(o, reduxStore: reduxStore, disposeBag: disposeBag)
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
                assertionFailureUnreachable(); return SpaceBoxSectionController()
            }
        }
    }
}
#endif
