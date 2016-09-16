//
//  TableSchemaViewController.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

class TableSchemaViewController: TableDataNavigationViewController {

    lazy var dataDelegate: TableDataDelegate = {
        let delegate = TableDataDelegate()
        return delegate
    }()
    
    var tableName: String = ""
    
    deinit {
        unRegisterMultiDelegate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerMultiDelegate()
        self.tableDelegateConfig()
        self.tableView?.xx_updateColumnsWithItems(self.tableColumnItems())
    }
    
    
    func fetchData() {
        
        DispatchQueue.back.async {
            let table = DataStoreBO.shared.tableInfoWithName(tableName: self.tableName)
            self.dataDelegate.setData(data: table.fields as AnyObject?)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }

    }
    
    
    override func tableColumnItems() -> [TableColumnItem] {
       
        let col1 = TableColumnItem()
        col1.title = "Name"
        col1.identifier = "name"
        col1.width = 120
        col1.minWidth = 120
        col1.maxWidth = 120
        col1.editable = true
        col1.textColor = NSColor.highlightColor
        col1.headerAlignment = .left
        col1.cellType = .textField
        
        let col2 = TableColumnItem()
        col2.title = "Type"
        col2.identifier = "type"
        col2.width = 100
        col2.minWidth = 100
        col2.maxWidth = 100
        col2.editable = true
        col2.textColor = NSColor.highlightColor
        col2.headerAlignment = .left
        col2.cellType = .comboBox
        col2.items = TypeKit.dbTypes()
        
        let col3 = TableColumnItem()
        col3.title = "NULL"
        col3.identifier = "isNULL"
        col3.width = 100
        col3.minWidth = 100
        col3.maxWidth = 100
        col3.editable = true
        col3.textColor = NSColor.highlightColor
        col3.headerAlignment = .left
        col3.cellType = .checkBox
        
        let col4 = TableColumnItem()
        col4.title = "Default Val"
        col4.identifier = "defaultVal"
        col4.width = 100
        col4.minWidth = 100
        col4.maxWidth = 100
        col4.editable = true
        col4.textColor = NSColor.highlightColor
        col4.headerAlignment = .left
        col4.cellType = .textField
        
        let col5 = TableColumnItem()
        col5.title = "Primary Key"
        col5.identifier = "isKey"
        col5.width = 100
        col5.minWidth = 100
        col5.maxWidth = 100
        col5.editable = true
        col5.textColor = NSColor.highlightColor
        col5.headerAlignment = .left
        col5.cellType = .checkBox
        
        return [    //col0,
            col1, col2, col3, col4, col5]
    }
    
    
    
    override func tableDelegateConfig() {
        self.tableView?.delegate   = self.dataDelegate
        self.tableView?.dataSource = self.dataDelegate
        self.dataDelegate.owner    = self.tableView
    }

    override func dataNavigationItemsConfig() -> [DataNavigationItem] {
        let insertItem = DataNavigationButtonItem()
        insertItem.imageName = NSImageNameAddTemplate
        insertItem.tooltips = "insert a row into current table"
        insertItem.tag = .add
        
        let deleteItem = DataNavigationButtonItem()
        deleteItem.imageName = NSImageNameRemoveTemplate
        deleteItem.tooltips = "delete seleted rows form current table"
        deleteItem.tag = .remove
        
        let refreshItem = DataNavigationButtonItem()
        refreshItem.imageName = NSImageNameRefreshTemplate
        refreshItem.tooltips = "reload table data"
        refreshItem.tag = .refresh

        return [insertItem,deleteItem,refreshItem]
     }
}


extension TableSchemaViewController: TableListSelectionStateDelegate {
    
    func registerMultiDelegate() {
        TableListStateManager.shared.addMultiDelegate(delegate: self, delegateQueue: nil)
    }
    
    func unRegisterMultiDelegate() {
        TableListStateManager.shared.removeMultiDelegate(delegate: self)
    }
    
    func selectedTableChanged(sender: AnyObject, tableName: String) {
        print("Schema selectedTableChanged \(tableName)")
        self.tableName = tableName
        self.fetchData()
    }
}
