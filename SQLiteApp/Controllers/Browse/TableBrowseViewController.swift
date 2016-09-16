//
//  TableBrowseViewController.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

class TableBrowseViewController: TableDataNavigationViewController {

    lazy var dataDelegate: TableDataDelegate = {
        let delegate = TableBrowseViewDelegate()
        return delegate
    }()
    
    var tableName: String = ""
    
    var datas: Array = [Dictionary<String,AnyObject>]()
    
    lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "macdec.io.BrowseView")
        return queue
    }()
    
    
    deinit {
        unRegisterMultiDelegate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableDelegateConfig()
        self.registerMultiDelegate()
        
        self.contextMenuConfig()
        
        //计算分页数据
        self.pageManager.delegate = self
        self.pageManager.pageSize = 10;
        
    }

    override func tableDelegateConfig() {
        self.tableView?.delegate   = self.dataDelegate
        self.tableView?.dataSource = self.dataDelegate
        self.dataDelegate.owner    = self.tableView
        
        self.dataDelegate.rowObjectValueChangedCallback = {
            obj , oldObj , row , fieldName in
            if row >= self.datas.count {
                return
            }
            self.datas[row] = obj as! Dictionary<String, AnyObject>
        }
    }
    
    
    
    
    func tableViewUpdateColumns(fields: [FieldInfo]) {
        if fields.count <= 0 {
            return
        }
        var tableViewColumns = [TableColumnItem]()
        for field: FieldInfo in fields {
            let col = TableColumnItem()
            col.title = field.name
            col.identifier = field.name
            col.width = 120
            col.minWidth = 120
            col.maxWidth = 120
            col.editable = true
            col.headerAlignment = .center
            col.cellType = .textField
            tableViewColumns.append(col)
        }
        self.tableView?.xx_updateColumnsWithItems(tableViewColumns)
    }
    
    //MARK: Table Context Menu
    
    lazy var tableCellMenu: NSMenu = {
        let tableCellMenu = NSMenu()
        var item = NSMenuItem()
        item.title = "Copy as JSON"
        tableCellMenu.addItem(item)
        item = NSMenuItem()
        item.title = "Copy as XML"
        tableCellMenu.addItem(item)
        return tableCellMenu
        
    }()
    
    func contextMenuConfig() {
        //关联菜单到tableView
        self.tableView?.menu = self.tableCellMenu
        let menus = self.tableCellMenu.items
        var opIndex = 0
        for item: NSMenuItem in menus {
            item.target = self
            item.tag = opIndex
            item.action = #selector(self.tableCellMenuItemClick)
            opIndex += 1
        }
    }
    
    

    @IBAction func tableCellMenuItemClick(sender: AnyObject) {
        let item = sender
        let index = item.tag
        let selectedRow = self.tableView?.selectedRow
        if selectedRow! < 0 {
            return
        }
        var data = self.dataDelegate.itemOf(row: selectedRow!) as! [String:AnyObject]
        if index == 0 {
            let json = data.jsonString()
            NSPasteboard.copyString(str: json!, owner: self)
        }
        if index == 1 {
            let table = DataStoreBO.shared.tableInfoWithName(tableName: self.tableName)
            let fields = table.fields
            var strs = String()
            for field: FieldInfo in fields {
                let val = data[field.name]
                let colStr = "<column name=\"\(field.name)\">\(val!)</column>"
                strs += colStr
                strs += "\n"
            }
            NSPasteboard.copyString(str: strs, owner: self)
        }
    }
    
}

extension TableBrowseViewController: TableListSelectionStateDelegate {
    
    func registerMultiDelegate() {
        TableListStateManager.shared.addMultiDelegate(delegate: self, delegateQueue: nil)
    }
    
    func unRegisterMultiDelegate() {
         TableListStateManager.shared.removeMultiDelegate(delegate: self)
    }
    
    func selectedTableChanged(sender: AnyObject, tableName: String) {
        print("Browse selectedTableChanged \(tableName)")
        
        let table = DataStoreBO.shared.tableInfoWithName(tableName: tableName)
        self.tableName = tableName
        let fields = table.fields
        DispatchQueue.main.async {
            self.tableViewUpdateColumns(fields: fields)
            self.tableViewSortColumnsConfig()
            //计算分页数据
            self.pageManager.computePageNumbers()
            //导航到第一页
            self.pageManager.goFirstPage()
            //更新导航面板分页提示信息
            self.updatePageInfo()

        }
    }
}


extension TableBrowseViewController: PaginatorDelegate {
    
    func paginator(id:AnyObject , pageIndex index:Int, pageSize size:Int ) {
        
        DispatchQueue.back.async {
            let sql = "select * from \(self.tableName)"
            let datas =  DataStoreBO.shared.defaultDao.sqlQuery(sql: sql, pageIndex: index, pageSize: size)
            self.dataDelegate.setData(data: datas as AnyObject?)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.updatePageInfo()
            }
        }
    }
    
    func totalNumberOfData(_ id:AnyObject) ->Int {

        let sql = "select * from \(self.tableName)"
        return DataStoreBO.shared.defaultDao.numbersOfRecordWithSQL(sql: sql)
    }
}


