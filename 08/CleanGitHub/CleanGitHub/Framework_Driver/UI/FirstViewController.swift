//
//  FirstViewController.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/17.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, ReposPresenterOutput {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didUpdate(_ viewModels: [RepoStatus]) {
        // TODO
    }

}

