//
//  DataNavigationView.swift
//  DataNavigationView
//
//  Created by iDevFans on 16/8/17.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa


let kToolbarPreImageName   = "pre"
let kToolbarFirstImageName = "first"
let kToolbarNextImageName  = "next"
let kToolbarLastImageName  = "last"

let kInfoIdentifier   = "info"
let kPagesIdentifier  = "pages"

class DataNavigationView: NSView {
    var items: [AnyObject] =  []
    var leftViews: [NSView] = [] //左边按钮视图集
    var flexibleView: NSView?   //中间Center区域
    var rightViews: [NSView] = []  //右边按钮视图集
    
    //顶部一条横线
    lazy var topLine:NSBox = {
       let line = NSBox()
       //使用NSBox控件的分隔线模式
       line.boxType = .separator
       line.translatesAutoresizingMaskIntoConstraints = false
       return line
    }()
    weak var target: AnyObject?
    
    var action: Selector?  {
        
        didSet {
            let viewSet = NSSet(array: leftViews)
            viewSet.addingObjects(from: rightViews)
            for view in viewSet {
                if view is NSButton {
                    let btn = view as! NSButton
                    btn.target = self.target
                    btn.action = self.action
                }
            }
        }
    }
   
    
    //配置默认的按钮组视图
    func setUpDefaultNavigationView() {
        let buttonItems = self.defaultItemsConfig()
        self.setUpNavigationViewWithItems(buttonItems)
    }
    
    //按items配置不同的按钮组
    func setUpNavigationViewWithItems(_ buttonItems: [AnyObject]) {
        self.items = buttonItems
        self.addNavigationItemsToView()
    }
    
    //默认的按钮配置
    func defaultItemsConfig() ->[AnyObject] {
        let item1 = DataNavigationButtonItem()
        item1.imageName = NSImageNameAddTemplate
        item1.tag = .add
        
        let item2 = DataNavigationButtonItem()
        item2.imageName = NSImageNameRemoveTemplate
        item2.tag = .remove

        let item3 = DataNavigationButtonItem()
        item3.imageName = NSImageNameRefreshTemplate
        item3.tag = .refresh

        
        return [item1,item2,item3]
    }
    

    
    /*
     -------------------------------------------------
     ［B B B］ ［---------------------------][B B - B B］
     -------------------------------------------------
     
     中间区域是一个空白区域,可以做为信息面板,显示提示说明信息。
     
     */
    
    func addNavigationItemsToView() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.addSubview(self.topLine)
        
        var hasFlexibleView: Bool = false
        var itemView: NSView?
        for item in self.items {
            itemView = nil
            if let buttonItem = item as? DataNavigationButtonItem {
                itemView = self.buttonWithItem(buttonItem)
            }
            else if let textItem = item as? DataNavigationTextItem {
                itemView = self.textLabelWithItem(textItem)
            }
            else if item is DataNavigationFlexibleItem {
                //中间区域,使用一个Text Lable占位
                self.flexibleView = self.infoLabel()
                self.addSubview(self.flexibleView!)
                hasFlexibleView = true
            }
            
            if let view = itemView {
                self.addSubview(view)
                if !hasFlexibleView {
                    self.leftViews.append(view)
                }
                else {
                    self.rightViews.append(view)
                }
            }
        }
        
        self.layoutNavigationView()
    }
    
    
    //对按钮组进行布局
    func layoutNavigationView() {
        
        //顶部一条横线布局配置（顶部，左边，右边）
        let topLineTop = self.topLine.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let topLineLeft =  self.topLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let topLineRight = self.topLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        //let topLineHeight = self.topLine.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([topLineTop, topLineLeft, topLineRight])
        
        
        
        var leftLastView: NSView?
        
        var left: NSLayoutConstraint?
       

        //当button是左边区域的第一个元素时，它的左边参考DataNavigationView的左边布局
        //否则参考leftLastView及button的左邻居布局
        for view in self.leftViews {
            let width = view.heightAnchor.constraint(equalToConstant: 24)
            let height = view.widthAnchor.constraint(equalToConstant: 24)
            let centerY = view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            if leftLastView == nil {
                left =  view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4)
            }
            else {
                left =  view.leftAnchor.constraint(equalTo: (leftLastView?.rightAnchor)!, constant: 4)
            }
            //激活自动布局约束，相当于增加约束到布局引擎
            NSLayoutConstraint.activate([left!, centerY, width, height])
            //保存当前view做为下一次循环处理的button的左邻居
            leftLastView = view
        }
        
        if self.rightViews.count <= 0 {
            return
        }
        
        var rightLastView: NSView?
        //数组逆序  即 ［2，3，7］ ＝ > [7,3,2]
        let reverseRightViews = self.rightViews.reversed()
        
        var right: NSLayoutConstraint?
        //从右边button区域最右边的第一个button的开始布局
        for view in reverseRightViews {
            
            let width = view.heightAnchor.constraint(equalToConstant: 24)
            let height = view.widthAnchor.constraint(equalToConstant: 24)
            let centerY = view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            if rightLastView == nil {
                right =  view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4)
            }
            else {
                right =  view.rightAnchor.constraint(equalTo: (rightLastView?.leftAnchor)!, constant: -4)
            }
            
            if view is NSTextField {
                let left  =  view.leftAnchor.constraint(equalTo: (rightLastView?.leftAnchor)!, constant: -64)
                NSLayoutConstraint.activate([left, right!, centerY])
            }
            else {
                NSLayoutConstraint.activate([right!, centerY, width, height])
            }
            
            rightLastView = view
        }

        
        //与Center区域右边相邻的第一个button
        let neighborButton = self.rightViews[0]
        
        //中间区域的约束,与左边，右边邻居各偏离4个像素
        let flexibleLeft = self.flexibleView?.leftAnchor.constraint(equalTo: (leftLastView?.rightAnchor)!, constant: 4)
        let flexibleRigth = self.flexibleView?.rightAnchor.constraint(equalTo: neighborButton.leftAnchor, constant: 4)
        let centerY = self.flexibleView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        
        NSLayoutConstraint.activate([flexibleLeft!, flexibleRigth!, centerY!])
    }

    //根据item创建button
    func buttonWithItem(_ item:DataNavigationButtonItem) ->NSButton {
        let button = NSButton()
        //设置按钮图标
        button.image = NSImage(named: item.imageName!)
        button.setButtonType(.momentaryPushIn)
        //无边框
        button.isBordered = false
        button.bezelStyle = .rounded
        button.isEnabled = true
        button.state = NSOnState
        button.identifier = item.identifier
        button.toolTip = item.tooltips
        //设置按钮事件响应方法
        button.target = self.target
        button.action = self.action
        button.tag = (item.tag?.rawValue)!
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }


    //根据item创建Text Label
    func textLabelWithItem(_ item:DataNavigationTextItem) ->NSTextField {
        let textLabel = self.infoLabel()
        textLabel.stringValue = item.title!
        textLabel.identifier = item.identifier
        textLabel.textColor = item.textColor
       
        return textLabel
    }
    
    //创建一个空字串的占位视图
    func infoLabel() ->NSTextField {
        let label = NSTextField()
        label.alignment = .center
        label.identifier = kInfoIdentifier
        label.font = NSFont.labelFont(ofSize: 12)
        label.stringValue = ""
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    //根据identifier更新文本串的字符
    func updateLabelWithIdentifier(_ identifier:String, title labelTitle: String) {
        for view in self.subviews {
            if view.identifier == identifier {
                if let label = view as? NSTextField {
                    label.stringValue = labelTitle
                    break
                }
            }
        }
    }
    
    
    //根据identifier更新文本串的字符
    func updateInfoLabel(title labelTitle: String) {
        self.updateLabelWithIdentifier(kInfoIdentifier, title: labelTitle)
    }
    
    //根据identifier更新文本串的字符
    func updatePagesLabel(title labelTitle: String) {
        self.updateLabelWithIdentifier(kPagesIdentifier, title: labelTitle)
    }
    

}




