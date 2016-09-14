//
//  TableQueryViewController.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

class TableQueryViewController: TableDataNavigationViewController {

    @IBOutlet weak var queryTableXibView: NSTableView!
    
    @IBOutlet weak var queryTableScrollXibView: NSScrollView!
    
    @IBOutlet weak var queryNavigationXibView: DataNavigationView!
    
    @IBOutlet var queryTextView: NSTextView!
    
    var sql = ""
    
    lazy var dataDelegate: TableDataDelegate = {
        let delegate = TableDataDelegate()
        return delegate
    }()
    
    lazy var sqlSyntxView: MGSFragaria = {
        let syntxView = MGSFragaria()
        syntxView.setShowsLineNumbers(false)
        syntxView.setObject("Sql", forKey: MGSFOSyntaxDefinitionName)
        return syntxView
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sqlSyntxView.embed(in: self.queryTextView)
        // Do view setup here.
        //计算分页数据
        self.pageManager.delegate = self
        self.pageManager.pageSize = 10;
    }
    
    
    override func tableDelegateConfig() {
        self.tableView?.delegate   = self.dataDelegate
        self.tableView?.dataSource = self.dataDelegate
        self.dataDelegate.owner    = self.tableView
    }


    // MARK: Action
    
    
    @IBAction func clearSQLAction(_ sender: AnyObject) {

        self.queryTextView.string = ""
    }
    @IBAction func runSQLAction(_ sender: AnyObject) {
   
        print("self.queryTextView.string \(self.sqlSyntxView.string)")
        var sql = self.sqlSyntxView.string()!
        if sql.characters.count <= 0 {
            return
        }
        self.sql = sql
        let datas = DataStoreBO.shared.defaultDao.sqlQuery(sql: sql, pageIndex: 0, pageSize: 1)

        if (datas?.count)! > 0 {
            let data = datas![0] as! [String:AnyObject]
            let fieldNames = Array(data.keys)
            self.tableViewUpdateColumnWithNames(fieldNames: fieldNames)
        }
        //计算分页数据
        self.pageManager.computePageNumbers()
        //导航到第一页
        self.pageManager.goFirstPage()
        //更新导航面板分页提示信息
        self.updatePageInfo()
    }


    
    func tableViewUpdateColumnWithNames(fieldNames: [String]) {
        if fieldNames.count <= 0 {
            return
        }
        var tableViewColumns = [TableColumnItem]() /* capacity: fieldNames.count */
        for name: String in fieldNames {
            let col = TableColumnItem()
            col.title = name
            col.identifier = name
            col.width = 120
            col.minWidth = 120
            col.maxWidth = 120
            col.editable = true
            col.headerAlignment = .left
            col.cellType = .textField
            tableViewColumns.append(col)
        }
        self.tableView?.xx_updateColumnsWithItems(tableViewColumns)
    }
    
    // MARK: ivars
    
    override func tableViewXibScrollView() ->NSScrollView? {
        return self.queryTableScrollXibView
    }
    
    override func tableXibView() ->NSTableView? {
        return self.queryTableXibView
    }
    
    override func dataNavigationXibView() ->DataNavigationView? {
        return self.queryNavigationXibView
    }
    
    
}


extension TableQueryViewController: PaginatorDelegate {
    
    func paginator(id:AnyObject , pageIndex index:Int, pageSize size:Int ) {
        
         DispatchQueue.back.async {
            let datas =  DataStoreBO.shared.defaultDao.sqlQuery(sql: self.sql, pageIndex: index, pageSize: size)
            self.dataDelegate.setData(data: datas as AnyObject?)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.updatePageInfo()
            }
        }
    }
    
    func totalNumberOfData(_ id:AnyObject) ->Int {
        return DataStoreBO.shared.defaultDao.numbersOfRecordWithSQL(sql: self.sql)
    }
}

