//
//  TableListViewController.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

let kSQLiteDBSavePath = "SQLiteDBSavePath"

class TableListViewController: NSViewController {

    @IBOutlet var tableNodeMenu: NSMenu!
    
    @IBOutlet var dataBaseNodeMenu: NSMenu!
    
    @IBOutlet weak var treeView: TableListView!
    
    lazy var treeViewDelegate: TableListViewDelegate = {
        let delegate = TableListViewDelegate()
        return delegate
    }()
    
    lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "macdec.io.TableListView")
        return queue
    }()
    
    deinit {
        unRegisterMultiDelegate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //先判断是否存在上次打开过的数据库路径
        if let dbPath = UserDefaults.standard.object(forKey: kSQLiteDBSavePath) as? String {
            if !DataStoreBO.shared.openDBWithPath(path: dbPath) {
                print("Open Db \(dbPath) Failed!")
                return
            }
        }
        else {
            //没有上次的路径则打开默认数据库
            if !DataStoreBO.shared.openDefaultDB() {
                NSLog("Open Default Database Failed!")
                return
            }
        }
        
        self.treeViewStyleConfig()
        self.registerFilesDrag()
        self.registerMultiDelegate()
        self.registerNotification()
        self.treeViewDelegateConfig()
        self.treeViewMenuConfig()
        
        //开始获取数据中的表信息
        self.fetchData()
        // Do view setup here.

        
    }
    
    func treeViewStyleConfig() {
        self.treeView.allowsMultipleSelection = true
        let color = NSColor(hex:0xd7dde5)
        self.treeView.backgroundColor = color
    }
    
    func registerFilesDrag() {
        self.treeView.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    
    func treeViewDelegateConfig() {
        self.treeView.delegate = self.treeViewDelegate
        self.treeView.dataSource = self.treeViewDelegate
        self.treeViewDelegate.owner = self.treeView
        self.treeViewDelegate.selectionChangedCallback = {(item: AnyObject, parentItem: AnyObject?) -> Void in
            let treeNode = item as! TreeNodeModel
            if treeNode.type == kDatabaseNode {
                return
            }
            let tableName = treeNode.name
            
            TableListStateManager.shared.multiDelegate.selectedTableChanged(tableName: tableName)
        }
       
        self.treeViewDelegate.dragFileCallBack = { [weak self]  (path: String) -> Void in
            self!.openDatabaseWithPath(path: path)
        }
    }
    
    func registerNotification() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.onOpenSQLiteFile(_:)),  name:NSNotification.Name.onOpenDBFile, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.onCloseSQLiteFile(_:)),  name:NSNotification.Name.onCloseDBFile, object: nil)
    }
    
    
    func onOpenSQLiteFile(_ notification: Notification){
        let path = notification.object as! String
        self.openDatabaseWithPath(path: path)
    }
    
    func onCloseSQLiteFile(_ notification: Notification){
        self.closeDatabase()
    }
    
    
    func treeViewMenuConfig() {
        self.treeView.tableNodeMenu    = self.tableNodeMenu
        self.treeView.dataBaseNodeMenu = self.dataBaseNodeMenu
    }
    
    func fetchData() {
        self.queue.async {
            let dbInfo = DataStoreBO.shared.databaseInfo
            
            let node = TreeNodeModel()
            node.name = dbInfo.dbName
            node.type = kDatabaseNode
            
            let tables = dbInfo.tables
            var tableNodes = [TreeNodeModel]()
            for table: TableInfo in tables {
                let childNode = TreeNodeModel()
                childNode.name = table.name
                childNode.type = kTableNode
                tableNodes.append(childNode)
            }
            node.childNodes = tableNodes
            self.treeViewDelegate.setData(data: node)
            DispatchQueue.main.async {
                self.treeView.reloadData()
                self.treeView.expandItem(nil, expandChildren: true)
                self.selectFirstTableNode()
            }
        }
    }
    
    func selectFirstTableNode() {
        let firstTableNode = self.treeView.item(atRow: 1)
        if firstTableNode == nil {
            return
        }
        let indexSet = IndexSet.init(integer: 1)
        self.treeView.selectRowIndexes(indexSet, byExtendingSelection: false)
        //使treeView 成为第一响应者
        self.view.window?.makeFirstResponder(self.treeView)
        let tableName = (firstTableNode as! TreeNodeModel).name
        TableListStateManager.shared.multiDelegate.selectedTableChanged(tableName: tableName)
    }

    
    func openDatabaseWithPath(path: String) {
        if !DataStoreBO.shared.openDBWithPath(path: path) {
            print("Open Db \(path) Failed!")
            return
        }
        
        UserDefaults.standard.set(path, forKey: kSQLiteDBSavePath)
        UserDefaults.standard.synchronize()
        
        self.fetchData()
    }
    
    func closeDatabase() {
        DataStoreBO.shared.clear()
        self.treeViewDelegate.clearAll()
        self.treeView.reloadData()
        TableListStateManager.shared.multiDelegate.closeDatabase()

    }

    //MARK : Menu Action
    
    @IBAction func duplicateTableMenuItemClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func renameTableMenuItemClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func dropTableMenuItemClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func emptyTableMenuItemClicked(_ sender: AnyObject) {
        
    }
    
   
    @IBAction func dataBaseOpenInFinderMenuItemClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func closeDatabaseMenuItemClicked(_ sender: AnyObject) {
        
    }
    
    
}

extension TableListViewController: TableListSelectionStateDelegate {
    
    
    func registerMultiDelegate() {
        TableListStateManager.shared.addMultiDelegate(delegate: self, delegateQueue: nil)
    }
    
    func unRegisterMultiDelegate() {
        TableListStateManager.shared.removeMultiDelegate(delegate: self)
    }
    
    func selectedTableChanged(sender: AnyObject, tableName: String) {
        print("selectedTableChanged \(tableName)")
    }
}
