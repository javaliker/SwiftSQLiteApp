//
//  NSTableView+ColumnItem.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/20.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Foundation
import Cocoa

private var itemKey = "itemKey"

extension NSTableView {
    var items: [TableColumnItem]? {
        get {
            if let itemObjs = objc_getAssociatedObject(
                self,
                &itemKey
                )
            {
                return itemObjs as? [TableColumnItem]
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self,
                                     &itemKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //删除所有的列
    func xx_removeAllColumns() {
        while self.tableColumns.count > 0 {
            let tableColumn = self.tableColumns.last
            self.removeTableColumn(tableColumn!)
        }
    }
    
    //使用items定义的TableColumnItem数组来创建列
    func xx_updateColumnsWithItems(_ items: [TableColumnItem]) {
        if items.count <= 0 {
            return
        }
        self.xx_removeAllColumns()
        self.items = items
        for item in items {
            let column = NSTableColumn.column(item)
            self.addTableColumn(column)
        }
    }
    
    //根据identifier获取列定义
    func xx_columnItemWithIdentifier(_ identifier: String) ->TableColumnItem? {
        for item in self.items! {
            if item.identifier == identifier {
                return item
            }
        }
        return nil
    }
    
    //根据index序号获取列定义
    func xx_columnItemAtIndex(_ index: Int) ->TableColumnItem? {
        if index >= (self.items?.count)! {
            return nil
        }
        return self.items?[index]
    }
    
    
    //设置某行某列选中的焦点状态
    func xx_setEditFoucusAtColumn(_ columnIndex: Int, atRow rowIndex: Int ) {
        if self.numberOfRows <= 0 {
            return
        }
        if rowIndex >= self.numberOfRows {
            return
        }
        
        self.xx_setSelectionAtRow(rowIndex)
        self.editColumn(columnIndex, row: rowIndex, with: nil, select: true)
    }
    
    //设置某列选中的状态
    func xx_setEditFoucusAtColumn(_ columnIndex: Int) {
        if self.numberOfRows <= 0 {
            return
        }
        self.xx_setEditFoucusAtColumn(columnIndex,atRow:self.numberOfRows-1)
    }
    
    //设置某行选中的状态
    func xx_setSelectionAtRow(_ rowIndex:Int) {
        if self.numberOfRows <= 0 {
            return
        }
        
        if rowIndex >= self.numberOfRows {
            return
        }
        
        let indexSet = IndexSet.init(integer: rowIndex)
        self.selectRowIndexes(indexSet, byExtendingSelection: false)
    }
    
    //失去焦点
    func xx_setLostEditFoucus() {
        let rowIndex = self.selectedRow
        if rowIndex < 0 {
            return;
        }
        
        for idx in self.selectedRowIndexes {
            self.deselectRow(idx)
        }
        for idx in self.selectedColumnIndexes {
            self.deselectColumn(idx)
        }
    }
}



