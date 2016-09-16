//
//  DataStoreBO.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/6.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

let kDefaultDatabaseName = "http://www.macdev.iosqlite"
let kDatabaseNode = "database"
let kTableNode    = "table"

class DataStoreBO: NSObject {

    private static let  sharedInstance = DataStoreBO()
    class var shared: DataStoreBO {
        return sharedInstance
    }
    
    lazy var databaseInfo: DatabaseInfo = {
        let dbInfo = DatabaseInfo()
        dbInfo.dbPath = (MDatabase.shared.dbPath?.path)!
        dbInfo.dbName = (MDatabase.shared.dbPath?.lastPathComponent)!
        dbInfo.tables = MDatabase.shared.tables()!
        return dbInfo
    }()
    
    lazy var defaultDao: DAO = {
        let dao = DAO()
        return dao
    }()
    
    func openDefaultDB() -> Bool {
        return MDatabase.shared.openDBWithName(dbName: kDefaultDatabaseName)
    }
    
    func openDBWithPath(path: String) -> Bool {
        self.clear()
        let ret =  MDatabase.shared.openDBWithPath(dbPath: URL(fileURLWithPath:path))
        self.refreshDBInfo()
        self.defaultDao = DAO()
        return ret
    }
    
    func clear() {
        MDatabase.shared.close()
    }
    
    func refreshTables() {
        self.databaseInfo.tables = MDatabase.shared.tables()!
    }
    
    func refreshDBInfo() {
        self.databaseInfo.dbPath = (MDatabase.shared.dbPath?.path)!
        self.databaseInfo.dbName = (MDatabase.shared.dbPath?.lastPathComponent)!
        self.databaseInfo.tables = MDatabase.shared.tables()!
    }
    
    func tableInfoWithName(tableName: String) -> TableInfo {
        return self.databaseInfo.tableInfo(withName: tableName)!
    }
}
