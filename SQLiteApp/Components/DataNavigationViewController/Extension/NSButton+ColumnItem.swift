//
//  NSButton+ColumnItem.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/20.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Foundation
import Cocoa


extension NSButton {
    convenience init(item: TableColumnItem) {
        self.init()
        self.setButtonType(.switch)
        self.bezelStyle = .regularSquare
        self.title = ""
        self.cell?.isBordered = false
        self.identifier = item.identifier.map { NSUserInterfaceItemIdentifier(rawValue: $0) }
    }
}


