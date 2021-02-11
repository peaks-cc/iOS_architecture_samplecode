import Redux
import RxSwift
import IGListKit
import RxCocoa

// refs. https://github.com/yuzushioh/RxIGListKit

protocol RxListAdapterDataSource: NSObjectProtocol {
    typealias Element = Redux.DataSourceElements
    var dataSourceElements: Element { get set }
    func listAdapter(_ adapter: IGListKit.ListAdapter, observedEvent: RxSwift.Event<Element>)
}

extension RxListAdapterDataSource {
    func listAdapter(_ adapter: IGListKit.ListAdapter, observedEvent: RxSwift.Event<Element>) {
        if case .next(let param) = observedEvent {
            dataSourceElements = param
            adapter.performUpdates(animated: param.animated)
        }
    }
}

extension Reactive where Base: IGListKit.ListAdapter {
    func items<DataSource: RxListAdapterDataSource & IGListKit.ListAdapterDataSource, O: RxSwift.ObservableType>(dataSource: DataSource)
        -> (_ source: O)
        -> Disposable where DataSource.Element == O.Element {
            weak var weakBase: IGListKit.ListAdapter? = self.base
            return { source in
                let subscription = source
                    .subscribe {
                        guard let weakBase = weakBase else { return }
                        dataSource.listAdapter(weakBase, observedEvent: $0)
                    }

                return RxSwift.Disposables.create {
                    subscription.dispose()
                }
            }
    }

    func setDataSource<DataSource: RxListAdapterDataSource & IGListKit.ListAdapterDataSource>(_ dataSource: DataSource) -> RxSwift.Disposable {
        base.dataSource = dataSource
        return RxSwift.Disposables.create()
    }
}

class AdapterDataSource: NSObject, IGListKit.ListAdapterDataSource, RxListAdapterDataSource, HasWeakStateDisposeBag {
    let reduxStore: ReduxStoreType
    weak var weakStateDisposeBag: RxSwift.DisposeBag?

    required init(_ reduxStore: ReduxStoreType, disposeBag: RxSwift.DisposeBag) {
        self.reduxStore = reduxStore
        self.weakStateDisposeBag = disposeBag
    }

    deinit {
        deinitLog()
    }

    var dataSourceElements: RxListAdapterDataSource.Element = DataSourceElements()

    func objects(for listAdapter: IGListKit.ListAdapter) -> [IGListKit.ListDiffable] {
        return dataSourceElements.elements
    }

    func emptyView(for listAdapter: IGListKit.ListAdapter) -> UIView? {
        return nil
    }

    func listAdapter(_ listAdapter: IGListKit.ListAdapter, sectionControllerFor object: Any) -> IGListKit.ListSectionController {
        fatalError("Should override")
    }
}

class SectionController<T: Diffable>: IGListKit.ListSectionController, HasWeakStateDisposeBag {
    typealias Element = T
    var dw: DiffableWrap<Element>
    var element: T { return dw.diffable }
    let reduxStore: ReduxStoreType
    var containerSize: CGSize {
        return collectionContext?.containerSize ?? .zero
    }
    weak var weakStateDisposeBag: RxSwift.DisposeBag?

    init(
        _ dw: DiffableWrap<Element>,
        reduxStore: ReduxStoreType,
        disposeBag: RxSwift.DisposeBag
    ) {
        self.dw = dw
        self.reduxStore = reduxStore
        self.weakStateDisposeBag = disposeBag
        super.init()
    }

    deinit {
        deinitLog()
    }

    override func didUpdate(to object: Any) {
        guard let object = object as? DiffableWrap<T> else { return }
        self.dw = object
    }

    // swiftlint:disable force_cast
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, at index: Int) -> T {
        let nib = String(describing: cellType)
        return collectionContext?.dequeueReusableCell(withNibName: nib, bundle: nil, for: self, at: index) as! T
    }
    // swiftlint:enable force_cast
}
