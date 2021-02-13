import UIKit
import RxSwift
import RxCocoa

import Kingfisher
import Redux

final class SettingViewController: UIViewController, HasWeakStateDisposeBag {
    typealias ThisState = SettingState
    let reduxStore: ReduxStoreType
    let state: Observable<ThisState>
    weak var weakStateDisposeBag: RxSwift.DisposeBag? // For HasWeakStateDisposeBag

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continerView: UIView!
    @IBOutlet weak var retryView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var serverErrorView: UIView!
    @IBOutlet weak var unknownErrorView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutButton: UIButton!

    init(reduxStore: ReduxStoreType, state: Observable<ThisState>, disposeBag: RxSwift.DisposeBag) {
        self.reduxStore = reduxStore
        self.state = state
        self.weakStateDisposeBag = disposeBag
        super.init(nibName: String(describing: SettingViewController.self), bundle: nil)
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
        titleLabel.text = String(describing: SettingViewController.self)

        state
            .bind(to: Binder(self) { $0.applyState($1) })
            .disposed(by: disposeBag)
        state
            .map { $0.avatarURL }
            .distinctUntilChanged()
            .bind(to: Binder(self) { $0.setAvatarImage(with: $1) })
            .disposed(by: disposeBag)
        state
            .compactMap { $0.shouldRequestTrigger }
            .distinctUntilChanged()
            .bind(to: Binder(self) { $0.request($1.connectionType) })
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .bind(to: Binder(self) { me, _ in me.presentLogin() })
            .disposed(by: disposeBag)

        logoutButton.rx.tap
            .bind(to: Binder(self) { me, _ in me.logout() })
            .disposed(by: disposeBag)
    }

    func setAvatarImage(with url: URL?) {
        avatarImageView.kf.setImage(with: url)
    }

    func request(_ connectionType: ConnectionType) {
        reduxStore.dispatch(
            ThisState.Action.requestAsyncCreator(
                connectionType: connectionType,
                disposeBag: disposeBag
            )
        )
    }

    func presentLogin() {
        reduxStore.dispatch(
            RoutingState.Action.transitionActionCreator(
                transitionStyle: .present,
                from: self,
                to: .login
            )
        )
    }

    func logout() {
        reduxStore.dispatch(AuthenticationState.Action.logout)
    }

    func applyState(_ state: ThisState) {
        nameLabel.text = state.userName
        loadingView.isShown = state.shouldShowLoading
        accountView.isShown = state.shouldShowUser
        loginView.isShown = state.shouldShowAuthenticated == false
        logoutView.isShown = state.shouldShowAuthenticated
        retryView.isShown = state.shouldShowNetworkError
        serverErrorView.isShown = state.shouldShowServerError
        unknownErrorView.isShown = state.shouldShowUnknownError
    }
}
