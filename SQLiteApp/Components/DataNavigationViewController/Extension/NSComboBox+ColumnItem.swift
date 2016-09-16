//
//  NSComboBox+ColumnItem.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/20.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Foundation
import Cocoa


extension NSComboBox {
    convenience init(item: TableColumnItem) {
        self.init()
        self.isEditable = item.editable
        self.isBordered = false
        self.isBezeled = false
        self.bezelStyle = .roundedBezel
        self.identifier = item.identifier
    }
}



