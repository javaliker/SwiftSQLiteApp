//
//  TableListView.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/6.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

class TableListView: NSOutlineView {

    weak var tableNodeMenu: NSMenu?

    weak var dataBaseNodeMenu: NSMenu?

    override func menu(for event: NSEvent) -> NSMenu? {
        let pt = self.convert(event.locationInWindow, from: nil)
        let row = self.row(at: pt)
        if row >= 0 {
            let item = self.item(atRow: row) as! TreeNodeModel
            let type = item.type
            if (type == kTableNode) {
                return self.tableNodeMenu
            }
            if (type == kDatabaseNode) {
                return self.dataBaseNodeMenu
            }
        }
        return super.menu(for: event)!
    }
}
