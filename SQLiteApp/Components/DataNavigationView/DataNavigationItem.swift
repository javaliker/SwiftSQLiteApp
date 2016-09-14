//
//  DataNavigationItem.swift
//  DataNavigationView
//
//  Created by iDevFans on 16/8/17.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

public enum DataNavigationViewButtonActionType : Int {
    
    case add
    
    case remove
    
    case refresh
    
    case first
    
    case pre
    
    case next
    
    case last
    
}


class DataNavigationItem: NSObject {
    var tooltips: String? //鼠标悬停的提示
    var identifier: String?//标识字符串
    var tag: DataNavigationViewButtonActionType? //按钮的tag
}

class DataNavigationTextItem: DataNavigationItem {
    var title: String?  //用作label的标题
    var textColor: NSColor? //文本颜色
    var alignment: NSTextAlignment = .center //文本的位置
}

class DataNavigationButtonItem: DataNavigationItem {
    var imageName: String?//按钮的图标名称
}

class DataNavigationFlexibleItem: DataNavigationItem {

}




