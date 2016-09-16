//
//  DispatchQueue+Ext.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/7.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

extension DispatchQueue {
    
    private static let  sharedQueueInstance = DispatchQueue(label: "macdec.io.SQLiteApp")

    static let  back = DispatchQueue(label: "macdec.io.SQLiteApp")

//    static func back() ->DispatchQueue {
//        return sharedQueueInstance
//    }

}


