//
//  TableDataNavigationViewDelegate.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/21.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

class TableDataNavigationViewDelegate: TableDataDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 24
    }
}


