//
//  TableInfo.swift
//  MDatabase
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Foundation

class TableInfo: NSObject {
    /** Table name */
    var name = ""
    /** Table Columns */
    var fields = [FieldInfo]()
    /** Table Primary Keys */
    var keys = [FieldInfo]()
}
