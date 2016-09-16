//
//  TableBrowseViewDelegate.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/7.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

class TableBrowseViewDelegate: TableDataDelegate {

    override func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
        return 24
    }
}




