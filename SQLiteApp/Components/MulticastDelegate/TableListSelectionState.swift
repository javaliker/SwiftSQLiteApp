//
//  TableListSelectionState.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/6.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

@objc protocol TableListSelectionStateDelegate  {
    @objc optional func selectedTableChanged(sender: AnyObject, tableName: String)
    @objc optional func closeDatabase(sender: AnyObject)
}

class TableListSelectionState: GCDMulticastDelegate,TableListSelectionStateDelegate {
    var currentTableName = ""
    
    func selectedTableChanged(tableName: String) {
        self.currentTableName = tableName
        let multiDelegate: TableListSelectionStateDelegate = self
        multiDelegate.selectedTableChanged!(sender: self, tableName: tableName)
    }
    
    func selectedTableChanged() {
        if currentTableName == "" {
            return
        }
        let multiDelegate: TableListSelectionStateDelegate = self
        multiDelegate.selectedTableChanged!(sender: self, tableName: self.currentTableName)
    }
    
    func closeDatabase () {
        let multiDelegate: TableListSelectionStateDelegate = self
        multiDelegate.closeDatabase!(sender: self)
    }
    
}

class TableListStateManager: NSObject {
    
    lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "macdec.io.StateManager")
        return queue
    }()
    
    private static let  sharedInstance = TableListStateManager()
    class var shared: TableListStateManager {
        return sharedInstance
    }
    
    lazy var multiDelegate: TableListSelectionState = {
        let delegate = TableListSelectionState()
        return delegate
    }()
    
    func addMultiDelegate(delegate:TableListSelectionStateDelegate, delegateQueue:DispatchQueue?){
        if delegateQueue == nil {
             multiDelegate.add(delegate, delegateQueue: self.queue)
        }
        else {
             multiDelegate.add(delegate, delegateQueue: delegateQueue)
        }
    }
    func removeMultiDelegate(delegate:TableListSelectionStateDelegate){
         multiDelegate.remove(delegate)
    }
}
