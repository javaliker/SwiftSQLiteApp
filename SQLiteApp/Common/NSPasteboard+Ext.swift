//
//  sfsf.swift
//  ImageAassetAutomator
//
//  Created by zhaojw on 2017/10/31.
//  Copyright © 2017年 macdev. All rights reserved.
//

import Cocoa

extension NSPasteboard {
    
    class func copyString(str: String, owner: AnyObject) {
        let pb = NSPasteboard.general
        let types = [NSPasteboard.PasteboardType.string]
        pb.declareTypes(types, owner: owner)
        if str != "" {
            pb.setString(str, forType: NSPasteboard.PasteboardType.string)
        }
    }
    
}


extension NSPasteboard.PasteboardType {
    static let backwardsCompatibleFileURL: NSPasteboard.PasteboardType = {
        if #available(OSX 10.13, *) {
            return NSPasteboard.PasteboardType.fileURL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeFileURL as String)
        }
        
    } ()
}
