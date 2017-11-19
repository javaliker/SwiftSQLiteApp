//
//  NSTextField+ColumnItem.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/20.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Foundation
import Cocoa


extension NSTextField {
    convenience init(item: TableColumnItem) {
        self.init()
        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = item.editable
        self.isSelectable = item.editable
        self.identifier = item.identifier.map { NSUserInterfaceItemIdentifier(rawValue: $0) }
    }
}






