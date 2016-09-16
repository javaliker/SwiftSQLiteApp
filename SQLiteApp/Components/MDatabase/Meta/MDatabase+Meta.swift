//
//  MDatabase+Meta.swift
//  MDatabase
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Foundation

extension MDatabase {
    
    func tables() -> [TableInfo]? {
        var tables = [TableInfo]()
        self.queue.inDatabase({ db in
            let sql = "SELECT * FROM sqlite_master where type = 'table' "
            var rs: FMResultSet?
            do {
                rs = try db!.executeQuery(sql,values: nil)
            }
            catch let error {
                print("error \(error)")
                return
            }
            
            while rs!.next() {
                let tableName = rs?.string(forColumn: "tbl_name")
                let table = TableInfo()
                table.name = tableName!
                tables.append(table)
            }
            rs?.close()
            
            for table: TableInfo in tables {
                let tableSQL = " PRAGMA table_info ( \(table.name) ) "
                var rs: FMResultSet?
                do {
                    rs = try db!.executeQuery(tableSQL,values: nil)
                }
                catch let error {
                    print("error \(error)")
                    continue
                }
                
                var fields = [FieldInfo]()
                var keys = [FieldInfo]()
                while rs!.next() {
                    //  NSDictionary *dict = [rs resultDictionary];
                    let field = FieldInfo()
                    let fName = rs?.string(forColumn: "name")
                    let fType = rs?.string(forColumn: "type")
                    
                    let isKey = rs?.bool(forColumn: "pk")
                    let isNULL = rs?.bool(forColumn: "notnull")
                    field.name = fName!
                    field.type = fType!
                    
                    if let defaultV = rs?.string(forColumn: "dflt_value") {
                         field.defaultVal = defaultV
                    }
                   
                    field.isKey = isKey!
                    field.isNULL = isNULL!
                    fields.append(field)
                    if field.isKey {
                        keys.append(field)
                    }
                }
                rs?.close()
                table.fields = fields
                table.keys = keys
            }
        })
        return tables
    }
}
