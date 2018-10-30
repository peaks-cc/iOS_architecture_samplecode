//
//  FirstViewController.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/17.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, ReposPresenterOutput {
    private weak var presenter: ReposPresenterProtocol!

    func update(by viewDataArray: [GitHubRepoViewData]) {
//        <#code#>
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //presenter.output = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didUpdate(_ viewModels: [GitHubRepoStatus]) {
        // TODO
    }

}

