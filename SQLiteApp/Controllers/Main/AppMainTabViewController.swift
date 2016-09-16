//
//  AppMainTabViewController.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

class AppMainTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewControllers()
        // Do view setup here.
    }
    
    func addChildViewControllers() {
        
        let dataViewController = TableBrowseViewController()
        dataViewController.title = "Browse"
        
        let schemaViewController = TableSchemaViewController()
        schemaViewController.title = "Schema"
        
        let queryViewController = TableQueryViewController(nibName: "TableQueryViewController", bundle: nil)!
        queryViewController.title = "Query"
        
        self.addChildViewController(dataViewController)
        self.addChildViewController(schemaViewController)
        self.addChildViewController(queryViewController)
    }
    
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        print("didSelectTabViewItem \(tabViewItem!)")
        
        TableListStateManager.shared.multiDelegate.selectedTableChanged()
        
    }
    
 
    
}
