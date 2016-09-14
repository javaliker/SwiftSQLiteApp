//
//  XibViewController.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/21.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

class XibViewController: NSViewController {

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        if nibNameOrNil == nil {
            super.init(nibName: "XibViewController", bundle: nibBundleOrNil)
        }
        else {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
