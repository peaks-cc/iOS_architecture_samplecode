import UIKit

class MessageListViewController: UIViewController {

    private let contentView: GitHubRepoController = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

class GitHubRepoController: UIViewController {
    let useCase: GitHubRepoUseCaseInput = .init()

    override func viewDidLoad() {
        
    }
}
