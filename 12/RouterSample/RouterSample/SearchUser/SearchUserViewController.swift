//
//  SearchUserViewController.swift
//  RouterSample
//
//  Created by Kenji Tanaka on 2018/09/23.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit

final class SearchUserViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
}

extension SearchUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        return cell
    }
}
