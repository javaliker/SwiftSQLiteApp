//
//  AppMainSplitViewController.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa


class AppMainSplitViewController: NSSplitViewController {

    lazy var tableListViewController: TableListViewController = {
        let vc = TableListViewController()
        return vc
    }()
    
    lazy var appMainTabViewController: AppMainTabViewController = {
        let vc = AppMainTabViewController()
        return vc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpControllers()
        self.configLayout()
        // Do view setup here.
    }
    
    
    func setUpControllers() {
        self.addChildViewController(self.tableListViewController)
        self.addChildViewController(self.appMainTabViewController)
    }

    
    func configLayout() {
        
        //设置左边视图的宽度最小100,最大300
        self.tableListViewController.view.width >= 100
        self.tableListViewController.view.width <= 260

        //设置右边视图的宽度最小300,最大2000
        self.appMainTabViewController.view.width >= 300
        self.appMainTabViewController.view.width <= 2000
        
    }
    
}
