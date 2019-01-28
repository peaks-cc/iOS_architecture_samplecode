import XCTest
import RxSwift
import RxCocoa
import IGListKit
import ReSwift
@testable import ReduxExample
@testable import Redux

class IGListKitViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let reduxStore: RxReduxStore
    let dataSource: AdapterDataSource
    let disposeBag = DisposeBag()
    lazy var dataSourceElementsBehavior: BehaviorRelay<DataSourceElements> =
        .init(value: dataSource.dataSourceElements)
    var didSetupConstraints = false

    init(reduxStore: RxReduxStore, dataSource: AdapterDataSource) {
        self.reduxStore = reduxStore
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)

        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
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
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}
