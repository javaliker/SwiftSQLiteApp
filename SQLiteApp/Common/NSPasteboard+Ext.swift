//
//  NSPasteboard+Ext.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/8.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

extension NSPasteboard {

    class func copyString(str: String, owner: AnyObject) {
        let pb = NSPasteboard.general()
        let types = [NSStringPboardType]
        pb.declareTypes(types, owner: owner)
        if str != "" {
            pb.setString(str, forType: NSStringPboardType)
        }
    }
    
}
