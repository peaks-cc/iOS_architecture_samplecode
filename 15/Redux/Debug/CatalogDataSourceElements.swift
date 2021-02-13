import Foundation
import ReSwift
import API
import GitHubAPI

#if DEBUG
public func createDebugCatalogDataSourceElements() -> DataSourceElements {
    let notice = Notice(id: 1, title: "Notice", routingPage: .webView(url: URL(string: "https://apple.com")!))

    let ds = DataSourceElements(animated: true)
    ds.append(TitleElement("TitleElement"))
    ds.append(TitleElement("┣ TitleSectionController"))
    ds.append(TitleElement("┗ TitleCell"))
    ds.append(TitleElement("Some title here"))

    ds.append(TitleElement("NoticeElement"))
    ds.append(TitleElement("┣ NoticeSectionController"))
    ds.append(TitleElement("┗ NoticeCell"))
    ds.append(NoticeElement(notice: notice))

    ds.append(TitleElement("RepositoryHeaderElement"))
    ds.append(TitleElement("┣ RepositoryHeaderSectionController"))
    ds.append(TitleElement("┗ RepositoryHeaderCell"))
    ds.append(RepositoryHeaderElement())

    ds.append(TitleElement("RepositoryElement"))
    ds.append(TitleElement("┣ RepositorySectionController"))
    ds.append(TitleElement("┗ RepositoryCell"))
    ds.append(RepositoryElement(createRepo(), isFavorite: true))

    ds.append(TitleElement("PublicRepositoryElement"))
    ds.append(TitleElement("┣ PublicRepositorySectionController"))
    ds.append(TitleElement("┗ PublicRepositoryCell"))
    ds.append(PublicRepositoryElement(createPublicRepo(), isFavorite: true))

    ds.append(TitleElement("ShowMoreRepositoryElement"))
    ds.append(TitleElement("┣ ShowMoreRepositorySectionController"))
    ds.append(TitleElement("┗ ShowMoreRepositoryCell"))
    ds.append(ShowMoreRepositoryElement(.repositoryType(isShowMore: true)))

    ds.append(TitleElement("AdvertisingElement"))
    ds.append(TitleElement("┣ AdvertisingSectionController"))
    ds.append(TitleElement("┗ AdvertisingCell"))
    ds.append(AdvertisingElement(PublicRepositoriesState.Action.hideAdvertising))

    ds.append(TitleElement("UserElement"))
    ds.append(TitleElement("┣ UserSectionController"))
    ds.append(TitleElement("┗ UserCell"))
    ds.append(PublicUserElement(createPublicUser()))

//    ds.append(TitleElement("ReadmeElement - isRenderedMarkdown: false"))
//    ds.append(TitleElement("┣ ReadmeSectionController"))
//    ds.append(TitleElement("┗ ReadmeCell"))
//    ds.append(ReadmeElement(ReadmeBase64, isRenderedMarkdown: false))

    ds.append(TitleElement("ReadmeElement - isRenderedMarkdown: true"))
    ds.append(TitleElement("┣ ReadmeSectionController"))
    ds.append(TitleElement("┗ ReadmeCell"))
    ds.append(ReadmeElement(Readme, isRenderedMarkdown: true))

    ds.append(TitleElement("LoadingElement"))
    ds.append(TitleElement("┣ LoadingSectionController"))
    ds.append(TitleElement("┗ LoadingCell"))
    ds.append(LoadingElement())

    ds.append(TitleElement("NetworkErrorElement"))
    ds.append(TitleElement("┣ NetworkErrorSectionController"))
    ds.append(TitleElement("┗ NetworkErrorCell"))
    ds.append(NetworkErrorElement())

    ds.append(TitleElement("UnknownErrorElement"))
    ds.append(TitleElement("┣ UnknownErrorSectionController"))
    ds.append(TitleElement("┗ UnknownErrorCell"))
    ds.append(UnknownErrorElement())

    return ds
}

func createPublicUser() -> GitHubAPI.PublicUser {
    return GitHubAPI.PublicUser(
        avatarUrl: "https://assets-cdn.github.com/images/modules/logos_page/GitHub-Mark.png",
        gravatarId: nil,
        id: 1,
        login: "LoginName",
        url: "https://github.com")
}

func createPublicRepo() -> GitHubAPI.PublicRepo {
    return GitHubAPI.PublicRepo(
        description: "Blazing fast Markdown rendering in Swift, built upon cmark.",
        fork: false,
        fullName: "FullName",
        htmlUrl: nil,
        id: 1,
        name: "Name",
        owner: Owner(avatarUrl: nil, gravatarId: nil, id: 1, login: "Owner", url: ""),
        _private: false,
        url: "")
}

func createRepo() -> GitHubAPI.Repo {
    return GitHubAPI.Repo(
        cloneUrl: "",
        createdAt: "",
        description: "Blazing fast Markdown rendering in Swift, built upon cmark.",
        fork: false,
        forks: 999,
        forksCount: 999,
        fullName: "FullName",
        gitUrl: "",
        hasDownloads: false,
        hasIssues: false,
        hasWiki: false,
        homepage: nil,
        htmlUrl: "",
        id: 1,
        language: "Swift",
        masterBranch: nil,
        mirrorUrl: nil,
        name: "FUGA",
        openIssues: 999,
        openIssuesCount: 999,
        organization: nil,
        owner: Owner(avatarUrl: nil, gravatarId: nil, id: 1, login: "Owner", url: ""),
        parent: nil,
        _private: false,
        pushedAt: "",
        size: 0,
        source: nil,
        sshUrl: "",
        svnUrl: nil,
        updatedAt: "",
        url: "",
        watchers: 999,
        watchersCount: 999)
}

// swiftlint:disable identifier_name
// swiftlint:disable line_length
private let Readme = "# MarkdownView\n\n[![CI Status](http://img.shields.io/travis/keitaoouchi/MArkdownView.svg?style=flat)](https://travis-ci.org/keitaoouchi/MarkdownView)\n[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://swift.org/)\n[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)\n[![Version](https://img.shields.io/cocoapods/v/MarkdownView.svg?style=flat)](http://cocoapods.org/pods/MarkdownView)\n[![License](https://img.shields.io/cocoapods/l/MarkdownView.svg?style=flat)](http://cocoapods.org/pods/MarkdownView)\n\n> MarkdownView is a WKWebView based UI element, and internally use bootstrap, highlight.js, markdown-it.\n\n!"
// swiftlint:enable identifier_name
// swiftlint:enable line_length

#endif
