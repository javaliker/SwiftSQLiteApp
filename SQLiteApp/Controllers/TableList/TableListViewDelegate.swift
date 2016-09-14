//
//  TableListViewDelegate.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/6.
//  Copyright © 2016年 macdev. All rights reserved.
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
    // MARK: -Drag File
    
    func outlineView(outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any, proposedChildIndex index: Int) -> NSDragOperation {
        // Add code here to validate the drop
        return .every
    }
    
    func outlineView(ov: NSOutlineView, acceptDrop info: NSDraggingInfo, item targetItem: Any, childIndex index: Int) -> Bool {
        let pboard = info.draggingPasteboard()
        self.handleFileBasedDrops(pboard)
        return true
    }
    
    func handleFileBasedDrops(_ pboard: NSPasteboard) {
        let fileNames = pboard.propertyList(forType: NSFilenamesPboardType) as! [String]
        let count = fileNames.count
        if count > 0 {
            var i: Int
            i = count - 1
            while i >= 0 {
                let filePath = fileNames[i]
                if let callback = self.dragFileCallBack {
                   callback(filePath)
                }
                i -= 1
            }
        }
    }
}
