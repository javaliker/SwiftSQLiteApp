//
//  DatabaseInfo.swift
//  MDatabase
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Foundation

class DatabaseInfo: NSObject {
    var dbName = ""
    var dbPath = ""
    var tables = [TableInfo]()
    
    func tableInfo(withName tableName: String) -> TableInfo? {
        for table: TableInfo in self.tables {
            if (table.name == tableName) {
                return table
            }
        }
        return nil
    }
}
