//
//  SearchUsersDataSource.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class SearchUsersDataSource: NSObject {

    private let userStore: GithubUserStore
    private let actionCreator: ActionCreator

    private let cellIdentifier = "Cell"
    private var imageDataList: [IndexPath: Data] = [:]
    private let imageCache: NSCache<NSIndexPath, NSData> = {
        let cache = NSCache<NSIndexPath, NSData>()
        cache.countLimit = 50
        return cache
    }()

    init(userStore: GithubUserStore,
         actionCreator: ActionCreator) {
        self.userStore = userStore
        self.actionCreator = actionCreator

        super.init()
    }

    func configure(_ tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SearchUsersDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userStore.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let user = userStore.users[indexPath.row]
        cell.textLabel?.text = user.login

        let setImage: (Data, Bool) -> () = { data, animated in
            guard let imageView = cell.imageView else {
                return
            }

            let image = UIImage(data: data)
            if animated {
                UIView.transition(with: imageView,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: { imageView.image = image },
                                  completion: nil)
            } else {
                imageView.image = image
            }
        }

        if let data = imageCache.object(forKey: indexPath as NSIndexPath) as Data? {
            setImage(data, false)
        } else {
            let size = CGSize(width: cell.bounds.size.height, height: cell.bounds.size.height)
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 1)
            UIColor.white.set()
            UIRectFill(rect)
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            URLSession.shared.dataTask(with: user.avatarURL) { [indexPath, weak self] data, _, _ in
                guard let data = data else {
                    return
                }
                self?.imageCache.setObject(data as NSData, forKey: indexPath as NSIndexPath)
                DispatchQueue.main.async {
                    guard tableView.indexPath(for: cell) == indexPath else {
                        return
                    }
                    setImage(data, true)
                }
            }.resume()
        }

        return cell
    }
}

extension SearchUsersDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userStore.users[indexPath.row]
        actionCreator.setSelectedUser(user)
    }
}
