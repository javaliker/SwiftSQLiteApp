//
//  FieldInfo.swift
//  MDatabase
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Foundation

class FieldInfo: NSObject {
    var name = "" //字段名称
    var type: String = "" //字段数据库类型
    var defaultVal = ""  //缺省值
    var isNULL = false //是否为空
    var isKey = false  //是否为主键
  
    //字段数据库类型对应的swift类型
    var swiftType: String {
        get  {
            return TypeKit.swiftType(self.type.uppercased())!
        }
    }
    
    //数值类型
    var isSimpleType: Bool {
        get  {
            return TypeKit.isSimpleType(self.type.uppercased())
        }
    }
    
    //对象类型
    var isObjectType: Bool {
        get  {
            return TypeKit.isObjectType(self.type.uppercased())
        }
    }
    
    

    var isBOOL: Bool {
        get  {
            return self.type == "BOOL"
        }
    }
    
    
    var isINTEGER: Bool {
        get  {
            return self.type == "INT" || self.type == "INTEGER"
        }
    }
    
    
    var isAutoIncrement: Bool {
        get  {
            return self.type == "INTEGER" &&  self.isKey == true
        }
    }
    
    var isINT: Bool {
        get  {
            return self.type == "INT"
        }
    }

    var isLONG: Bool {
        get  {
            return self.type == "LONG"
        }
    }
    
    var isDOUBLE: Bool {
        get  {
            return self.type == "DOUBLE"
        }
    }
    
    var isFLOAT: Bool {
        get  {
            return self.type == "FLOAT"
        }
    }
    
    var isTEXT: Bool {
        get  {
            return self.type == "TEXT"
        }
    }
    
    var isVARCHAR: Bool {
        get  {
            return self.type.contains("CHAR")
        
        }
    }
    
    
    var isDATETIME: Bool {
        get  {
            return self.type == "DATETIME"
            
        }
    }
    
    var isNUMERIC: Bool {
        get  {
            return self.type == "NUMERIC"
            
        }
    }
    
    var isNSString: Bool {
        get  {
            return self.type == "NSSTRING"
            
        }
    }
    

    var isBLOB: Bool {
        get  {
            return self.type == "BLOB"
            
        }
    }


}
