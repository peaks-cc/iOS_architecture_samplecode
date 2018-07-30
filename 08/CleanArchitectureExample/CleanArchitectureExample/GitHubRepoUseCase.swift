import Foundation
import RxSwift

//MARK: Input
struct GitHubRepoUseCaseInput: UseCaseInputPort {

}

//MARK: Interactor
protocol GitHubRepoUseCaseInteractor: UseCaseInteractor {
    func search(repository: String,
                sort: GitHub.SearchRepositoriesSort,
                order: GitHub.Order) -> Observable<GitHubRepo>
    func search(commits: String,
                sort: GitHub.SearchCommitsSort,
                order: GitHub.Order) -> Observable<GitHubRepo>
    func search(code: String,
                sort: GitHub.SearchCodeSort,
                order: GitHub.Order) -> Observable<GitHubRepo>
    func postStar(identifier: String)
}

struct GitHubRepoUseCaseInteractorImpl: GitHubRepoUseCaseInteractor {
    typealias Input = GitHubRepoUseCaseInput
    let gitHubGateway: GitHubGateway
    let presenter: GitHubRepoListPresenterImpl

    func search(repository: String,
                sort: GitHub.SearchRepositoriesSort,
                order: GitHub.Order) -> Observable<GitHubRepo> {
        return gitHubGateway.search(
            repositories: repository,
            sort: sort,
            order: order
            )
            .map{.init(response: $0)}
    }

    func search(commits: String,
                sort: GitHub.SearchCommitsSort,
                order: GitHub.Order) -> Observable<GitHubRepo> {
        return gitHubGateway.search(
            commits: commits,
            sort: sort,
            order: order
            )
            .map{.init(response: $0)}
    }

    func search(code: String,
                sort: GitHub.SearchCodeSort,
                order: GitHub.Order) -> Observable<GitHubRepo> {
        return gitHubGateway.search(
            code: code,
            sort: sort,
            order: order
            )
            .map{.init(response: $0)}
    }

    func postStar(identifier: String) {

    }
}

//MARK: Output
protocol GitHubRepoUseCaseOutput: UseCaseOutputPort {
    var pagination: Pagination { get }
    var items: [GitHubRepo.Item] { get }
}

protocol GitHubRepoListPresenter: Presenter {
    var result: PublishSubject<GitHubRepo> { get }
}

class GitHubRepoListPresenterImpl: GitHubRepoListPresenter {
    typealias Output = GitHubRepoUseCaseOutput

    let result: PublishSubject<Output> = .init()
    private let disposeBag = DisposeBag()

    init() {
        result.subscribe(
            onNext: { [weak self] (output) in
                self?.execute(output: output)
            },
            onError: { [weak self] (error) in
                self?.execute(error: error)
        }).disposed(by: disposeBag)
    }

    func execute(output: Output) {

    }

    func execute(error: Error) {

    }
}

// Entity
struct GitHubRepo: GitHubRepoUseCaseOutput {
    let pagination: Pagination
    let items: [Item]

    struct Item {
        let id: Int
        let name: String
        let fullName: String
        let owner: Owner
        let itemPrivate: Bool
        let fork: Bool
        let size: Int
        let stargazersCount: Int
        let watchersCount: Int
        let language: String
        let forksCount: Int
        let archived: Bool
        let openIssuesCount: Int
        let forks: Int
        let score: Double

        struct Owner {
            let id: Int
            let login: String
            let nodeID: String
            let avatarURL: String
            let gravatarID: String
            let type: OwnerType?
            let siteAdmin: Bool

            init(response: GitHubRepoEntity.Owner) {
                id = response.id
                login = response.login
                nodeID = response.nodeID
                avatarURL = response.avatarURL
                gravatarID = response.gravatarID
                type = OwnerType(rawValue: response.type.rawValue)
                siteAdmin = response.siteAdmin
            }
        }

        enum OwnerType: String {
            case organization
            case user
        }
    }
}

extension GitHubRepo {
    init(response: Response<GitHubRepoEntity>) {
        self.pagination = Pagination(
            totalCount: response.body.totalCount,
            incompleteResults: response.body.incompleteResults,
            limit: response.header["X-RateLimit-Limit"] as! Int,
            remaining: response.header["X-RateLimit-Remaining"] as! Int
        )

        self.items = response.body.items.map {
            return GitHubRepo.Item(
                id: $0.id,
                name: $0.name,
                fullName: $0.fullName,
                owner: .init(response: $0.owner),
                itemPrivate: $0.itemPrivate,
                fork: $0.fork,
                size: $0.size,
                stargazersCount: $0.stargazersCount,
                watchersCount: $0.watchersCount,
                language: $0.language,
                forksCount: $0.forksCount,
                archived: $0.archived,
                openIssuesCount: $0.openIssuesCount,
                forks: $0.forks,
                score: $0.score
            )
        }
    }
}


struct Pagination {
    let totalCount: Int
    let incompleteResults: Bool
    let limit: Int
    let remaining: Int
}
