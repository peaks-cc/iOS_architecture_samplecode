import UIKit

class RepoDetailCoordinator: Coordinator {

    let navigator: UINavigationController
    let model: GitHubRepoModel
    var repoDetailViewController: RepoDetailViewController?

    init(navigator: UINavigationController, model: GitHubRepoModel) {
        self.navigator = navigator
        self.model = model
    }

    func start() {
        let viewController = RepoDetailViewController()
        viewController.repoURL = model.url
        self.navigator.pushViewController(viewController, animated: true)
        self.repoDetailViewController = viewController
    }
}
