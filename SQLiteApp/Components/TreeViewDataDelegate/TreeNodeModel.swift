//
//  TreeNodeModel.swift
//  NSOutlineView
//
//  Created by iDevFans on 16/7/11.
//  Copyright © 2016年 http://http://www.macdev.ioio. All rights reserved.
//

import Cocoa

class TreeNodeModel: NSObject {
    var name: String = ""
    var type: String = ""
    lazy var childNodes: Array = {
        return [TreeNodeModel]()
    }()
}
