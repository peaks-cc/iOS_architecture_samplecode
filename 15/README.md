# Redux with Rx example for iOS Apps

This is a sample App to learn redux architecture.

![](App.png)


## Requirements

- Xcode 12+
- Swift 5.3
- Ruby 2.3+
- Carthage 0.37.0

## Getting Started

### CocoaPods

```sh
$ bundle install --path=vendor/bundle --binstubs=vendor/bin
$ bundle exec pod install
```

### Carthage

```sh
$ carthage bootstrap --platform iOS --cache-builds --use-xcframeworks
```

### Obtaining GitHub API Key

1. Go to [Account Settings](https://github.com/settings/profile).
1. Select Developer settings from sidebar.
1. Register a new OAuth application.
1. Enter Application Name (e.g. ReduxSampleApp) and Homepage URL (e.g. https://peaks.cc/iOS_architecture).
1. Type peaks-redux://oauth for Authorization Callback URL.
1. Click to Register application.
1. Copy and paste Client ID and Client Secret to `Global.swift`


## Application description

This sample application consists of the following three layers.
In Xcode, each layer is divided as a target.

- App Layer
- Redux Layer
- API Layer

## Recommendation .gitignore for Carthage

We recommend against adding the Carthage directory to your .gitignore.

```.gitignore
# Carthage
#
# Add this line if you want to avoid checking in source code from Carthage dependencies.
Carthage/Checkouts ← Comment out
Carthage/Build ← Comment out
```

## Tnanks

FOLIO's iOS Team

- [Shunsuke Kondo](https://github.com/kndoshn) [@kndoshn](https://twitter.com/kndoshn)
- [Katsumi Kishikawa](https://github.com/kishikawakatsumi) [@k_katsumi](https://twitter.com/k_katsumi)
- [Takahiro Nishinobu](https://github.com/hachinobu) [@hachinobu1](https://twitter.com/hachinobu1)
- [Daiki Matsudate](https://github.com/d-date) [@d_date](https://twitter.com/d_date)

Code

- [marty-suzuki](https://github.com/marty-suzuki) LoginViewController ( GitHub login )
- [kishikawakatsumi](https://github.com/kishikawakatsumi) [Folio-UI-Collection](https://github.com/folio-sec/Folio-UI-Collection)
- [yuzushioh](https://github.com/yuzushioh) [RxIGListKit](https://github.com/yuzushioh/RxIGListKit)

Library

- [ReSwift/ReSwift](https://github.com/ReSwift/ReSwift)
- [Instagram/IGListKit](https://github.com/Instagram/IGListKit)
- [ReactiveX/RxSwift](https://github.com/ReactiveX/RxSwift)
- [RxSwiftCommunity/RxOptional](https://github.com/RxSwiftCommunity/RxOptional)
- [onevcat/Kingfisher](https://github.com/onevcat/Kingfisher)
- [kishikawakatsumi/KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
- [Alamofire/Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftyBeaver/SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver)

Tools

- [SwiftLint](https://github.com/realm/SwiftLint)
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)
- [OpenAPI](https://github.com/OAI/OpenAPI-Specification)
- [CocoaPods](https://cocoapods.org/)
- [Carthage](https://github.com/Carthage/Carthage)
