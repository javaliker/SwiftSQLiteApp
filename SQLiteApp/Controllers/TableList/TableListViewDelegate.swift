//
//  TableListViewDelegate.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/6.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

class TableListViewDelegate: TreeViewDataDelegate {

    override func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 28
    }
    
    override func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView {
        let model = item as! TreeNodeModel
        let type = model.type
        let result = outlineView.make(withIdentifier: type, owner: self)!
        let cell = result.subviews[1] as! NSTextField
        if model.name != "" {
            cell.stringValue = model.name
        }
        return result
    }
 
}
