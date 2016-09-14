//
//  TableColumnItem.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/19.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Foundation
import Cocoa
import AppKit

public enum TableColumnCellType : Int {
    case label
    case textField
    case comboBox
    case checkBox
    case imageView
}

class TableColumnItem: NSObject {

    //表头定义部分
    var title: String? //列标题
    var identifier: String?//表列Identifier
    var headerAlignment: NSTextAlignment = .center //列标题的alignment
    var width: CGFloat = 20 //列宽度
    var minWidth: CGFloat = 20 //列最小宽度
    var maxWidth: CGFloat = 20 //列最大宽度
    var editable: Bool = false //文本是否允许编辑
    
    //下面是表格单元内容部分
    var cellType: TableColumnCellType = .textField //表格单元视图的类型
    var textColor: NSColor? //文本的Color
    var items: [String]? //Combox类型的items数据
}

