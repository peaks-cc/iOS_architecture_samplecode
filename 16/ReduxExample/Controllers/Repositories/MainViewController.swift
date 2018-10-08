import UIKit
import RxSwift
import RxCocoa
import Redux

final class MainViewController: UIViewController, HasWeakStateDisposeBag {
    let reduxStore: RxReduxStore
    let state: Observable<AuthenticationState>
    weak var weakStateDisposeBag: RxSwift.DisposeBag? // For HasWeakStateDisposeBag

    init(reduxStore: RxReduxStore, state: Observable<AuthenticationState>, disposeBag: RxSwift.DisposeBag) {
        self.reduxStore = reduxStore
        self.state = state
        self.weakStateDisposeBag = disposeBag
        super.init(nibName: nil, bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        state.map { $0.isAuthenticated }
            .distinctUntilChanged()
            .bind(to: Binder(self) { $0.changeAuthenticated($1) })
            .disposed(by: disposeBag)
    }

    func changeAuthenticated(_ isAuthenticated: Bool) {
        children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        let routingPage: Routing.Page = isAuthenticated ? .userRepositories : .publicRepositories
        let vc = Router.controller(reduxStore, routingPage: routingPage)
        addChildHelper(vc)
    }
}
