//
//  NSColor+Ext.swift
//  LocalizationTools
//
//  Created by iDevFans on 16/8/27.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

extension NSColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    
    static func toolBarBackgroundColor() -> NSColor {
        return NSColor(patternImage: NSImage(named: "arches")!)
    }

}
