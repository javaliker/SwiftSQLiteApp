//
//  TypeKit.swift
//  MDatabase
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Foundation



class TypeKit {
    
    static var typeMaps: [String : String] =
                [
                 "INTEGER": "Int",
                 "INT": "Int",
                 "BOOL": "Bool",
                 "DOUBLE": "Double",
                 "FLOAT": "Float",
                 "TEXT": "String",
                 "VARCHAR": "String",
                 "DATETIME": "String",
                 "NUMERIC": "NSNumber",
                 "BLOB": "Data"
                 ]
    
    
    static var simpleMaps: [String] = ["BOOL",
                                     "INTEGER",
                                     "NSINTEGER",
                                     "NSUINTEGER",
                                     "LONG",
                                     "INT",
                                     "DOUBLE",
                                     "FLOAT",
                                     "NUMERIC"]
    
    
    class func swiftType(_ sqliteType: String) -> String? {
        return typeMaps[sqliteType]
    }
    
    class func itIsSimpleType(_ type: String) -> Bool {
        if simpleMaps.contains(type) {
            return true
        }
        return false
    }

    
    class func isSimpleType(_ type: String) -> Bool {
        return itIsSimpleType(type)
    }
    
    class func isObjectType(_ type: String) -> Bool {
        return !itIsSimpleType(type)
    }
    
    class func objectType(_ type: String) -> String? {
        var objcTypeStr = swiftType(type)
        if objcTypeStr == "" {
            objcTypeStr = "String"
        }
        return objcTypeStr
    }
    
    class func dbTypes() -> [String] {
        return ["INTEGER",
                "BOOL",
                "DOUBLE",
                "FLOAT",
                "TEXT",
                "VARCHAR",
                "DATETIME",
                "NUMERIC",
                "BLOB"]
    }
    
}
