//
//  RepositoryListViewController.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let repositoryListPresenter = RepositoryListPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryListPresenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

