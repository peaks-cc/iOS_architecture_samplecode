import UIKit

protocol RepoListViewControllerDelegate: AnyObject {
    func repoListViewControllerDidSelectRepo(_ repo: GitHubRepoModel)
}

class RepoListViewController: UIViewController {

    weak var delegate: RepoListViewControllerDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerNib(cell: RepoListTableViewCell.self)
        return tableView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: 実際にGitHubから取得する実装は省略しています。
    var repoList: [GitHubRepoModel] = [
        .init(name: "peaks-cc/iOS_architecture_samplecode", star: 1000, url: URL(string: "https://github.com/peaks-cc/iOS_architecture_samplecode")!),
        .init(name: "Alamofire/Alamofire", star: 30000, url: URL(string: "https://github.com/Alamofire/Alamofire")!)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub Repo Search"
        view.backgroundColor = .clear
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

extension RepoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: RepoListTableViewCell.self, for: indexPath)
        let model = repoList[indexPath.row]
        cell.set(model: model)
        return cell
    }
}

extension RepoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = repoList[indexPath.row]
        delegate?.repoListViewControllerDidSelectRepo(repo)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
