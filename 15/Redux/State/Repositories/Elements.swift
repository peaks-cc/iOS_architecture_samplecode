import Foundation
import ReSwift
import RxSwift
import API
import GitHubAPI

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Dummy Data
///////////////////////////////////////////////s///////////////////////////////////////////
public struct Notice {
    public typealias NoticeId = Int
    public let id: NoticeId
    public let title: String
    public let routingPage: Routing.Page
}

let notices: [Notice] = [
    Notice(id: 1, title: "お知らせ その１です。", routingPage: .webView(url: URL(string: "https://apple.com")!)),
    Notice(id: 2, title: "お知らせ その２です。", routingPage: .webView(url: URL(string: "https://google.com")!)),
    Notice(id: 3, title: "お知らせ その３です。", routingPage: .webView(url: URL(string: "https://yahoo.co.jp")!))
]

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Elements
///////////////////////////////////////////////s///////////////////////////////////////////
public struct NoticeElement: Diffable {
    public var identifier: Identifier
    private let notice: Notice
    public let title: String
    public var routingPage: Routing.Page { return notice.routingPage }

    init(notice: Notice) {
        self.identifier = .init("\(String(describing: NoticeElement.self))-\(notice.id)")
        self.notice = notice

        let random = (Int)(arc4random_uniform(UInt32(89))) + 10 // 10 ~ 99
        self.title = "[\(random)] \(notice.title)"
    }

    public static func == (lhs: NoticeElement, rhs: NoticeElement) -> Bool {
        return lhs.title == rhs.title
    }
}

public struct RepositoryHeaderElement: Diffable {
    public let identifier: Identifier = .init(RepositoryHeaderElement.self)
    public let url = URL(string: "https://github.com")!
    public var routingPage: Routing.Page { return .webView(url: self.url) }
}

public struct AdvertisingElement: Diffable {
    public let identifier: Identifier = .init(AdvertisingElement.self)
    public let url = URL(string: "https://peaks.cc/iOS_architecture")!
    public var routingPage: Routing.Page { return .webView(url: self.url) }
    public let title: String = "Please touch me!!"
    public let hideAdvertisingAction: ReSwift.Action

    init(_ hideAdvertisingAction: ReSwift.Action) {
        self.hideAdvertisingAction = hideAdvertisingAction
    }
}

public typealias RepositoryId = Int
public struct RepositoryElement: Diffable {
    public let identifier: Identifier
    public let id: RepositoryId
    public let updatedAt: String
    public let owner: String
    public let name: String
    public let descriptionForRepository: String
    public let launguage: String
    public let openIssuesCount: String
    public let forkCount: String
    public let watchersCount: String
    public let routingPage: Routing.Page
    public let isFavorite: Bool
    public var favorite: Favorite {
        return Favorite(id: self.id, owner: self.owner, name: self.name, descriptionForRepository: self.descriptionForRepository)
    }
    public var fullName: String { return "\(owner)/\(name)" }

    init(_ repo: GitHubAPI.Repo, isFavorite: Bool) {
        self.identifier = .init("\(String(describing: RepositoryElement.self))-\(repo.id)")
        self.id = repo.id
        self.updatedAt = repo.updatedAt
        self.owner = repo.owner.login
        self.name = repo.name
        self.descriptionForRepository = repo.description ?? ""
        self.launguage = repo.language ?? "N/A"
        self.openIssuesCount = String(describing: repo.openIssuesCount)
        self.forkCount = String(describing: repo.forksCount)
        self.watchersCount = String(describing: repo.watchersCount)
        self.routingPage = .repository((owner: repo.owner.login, repo: repo.name))
        self.isFavorite = isFavorite
    }

    public static func == (lhs: RepositoryElement, rhs: RepositoryElement) -> Bool {
        return lhs.updatedAt == rhs.updatedAt && lhs.isFavorite == rhs.isFavorite
    }
}

public typealias PublicRepositoryId = Int
public struct PublicRepositoryElement: Diffable {
    public let identifier: Identifier
    public let id: RepositoryId
    public let owner: String
    public let name: String
    public let descriptionForRepository: String
    public let routingPage: Routing.Page
    public let isFavorite: Bool
    public var favorite: Favorite {
        return Favorite(id: self.id, owner: self.owner, name: self.name, descriptionForRepository: self.descriptionForRepository)
    }
    public var fullName: String { return "\(owner)/\(name)" }

    init(_ repo: GitHubAPI.PublicRepo, isFavorite: Bool) {
        self.identifier = .init("\(String(describing: PublicRepositoryElement.self))-\(repo.id)")
        self.id = repo.id
        self.owner = repo.owner.login
        self.name = repo.name
        self.descriptionForRepository = repo.description ?? ""
        self.routingPage = .repository((owner: repo.owner.login, repo: repo.name))
        self.isFavorite = isFavorite
    }

    public static func == (lhs: PublicRepositoryElement, rhs: PublicRepositoryElement) -> Bool {
        return lhs.isFavorite == rhs.isFavorite
    }
}

public struct ShowMoreRepositoryElement: Diffable {
    public enum RepositoryType {
        case publicRepositoryType(isShowMore: Bool)
        case repositoryType(isShowMore: Bool)

        public var action: ReSwift.Action {
            switch self {
            case .repositoryType(let isShowMore):
                return UserRepositoriesState.Action.showMoreRepository(isShowMore: isShowMore)
            case .publicRepositoryType(let isShowMore):
                return PublicRepositoriesState.Action.showMoreRepository(isShowMore: isShowMore)
            }
        }
    }
    public let identifier: Identifier = .init(ShowMoreRepositoryElement.self)
    public let repositoryType: RepositoryType

    init(_ repositoryType: RepositoryType) {
        self.repositoryType = repositoryType
    }
}
