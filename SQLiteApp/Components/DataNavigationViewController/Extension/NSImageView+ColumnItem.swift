//
//  NSImageView+ColumnItem.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/20.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Foundation
import Cocoa
extension NSImageView {
    
    convenience init(item: TableColumnItem) {
        self.init()
        self.identifier = item.identifier
    }
    
}
