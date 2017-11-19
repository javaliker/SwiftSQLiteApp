//
//  TreeViewDataDelegate.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/5.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

//选择不同的行回调接口
typealias TreeNodeSelectChangedCallback =  ( _  item:AnyObject ,  _  parentItem: AnyObject?) -> ()
typealias DragFileCallbackBlock =  ( _  path: String) -> ()

class TreeViewDataDelegate: NSObject {
    
    weak var owner: NSOutlineView?
    
    var treeNodes: TreeNodeModel = TreeNodeModel()
    
    var selectionChangedCallback: TreeNodeSelectChangedCallback?
    var dragFileCallBack: DragFileCallbackBlock?

    func setData(data: TreeNodeModel) {
        self.clearAll()
        self.treeNodes.childNodes.append(data)
    }
    
    func append(data: TreeNodeModel) {
        self.treeNodes.childNodes.append(data)
    }
    
    func clearAll() {
        self.treeNodes.childNodes.removeAll()
    }
    
    func deleteData(data: AnyObject) {
        if data is IndexSet {
            let indexSet = data as! IndexSet
            let mutuDatas = NSMutableArray(array: self.treeNodes.childNodes)
            mutuDatas.removeObjects(at: indexSet)
            self.treeNodes.childNodes.removeAll()
            for obj in mutuDatas {
                self.treeNodes.childNodes.append(obj as! TreeNodeModel)
            }
        }
        else  if data is  [TreeNodeModel] {
            let datas = data as! [TreeNodeModel]
            for obj in datas {
                let index = self.treeNodes.childNodes.index(of: obj)
                if index != nil {
                     self.treeNodes.childNodes.remove(at: index!)
                }
            }
        }
        else {
            let obj = data as! TreeNodeModel
            let index = self.treeNodes.childNodes.index(of: obj)
            if index != nil {
                self.treeNodes.childNodes.remove(at: index!)
            }
        }
    }

    func indexOf(item: TreeNodeModel) ->Int?  {
        return self.treeNodes.childNodes.index(of: item)
    }

    func itemOf(row: Int) -> TreeNodeModel? {
        let count = self.treeNodes.childNodes.count
        if count == 0 || row >= count {
            return nil
        }
        return self.treeNodes.childNodes[row]
    }
    
    func itemsAt(indexSet: IndexSet) -> [TreeNodeModel] {
        let mutuDatas = NSMutableArray(array: self.treeNodes.childNodes)
        let items = mutuDatas.objects(at: indexSet) as! [TreeNodeModel]
        return items
    }
}

extension TreeViewDataDelegate: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        let view = outlineView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self)
        let subviews  = view?.subviews
        //let imageView = subviews?[0] as! NSImageView
        
        let field = subviews?[1] as! NSTextField
        let model = item as! TreeNodeModel
        
        field.stringValue = model.name
        return view
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 40
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        let treeView = notification.object as! NSOutlineView
        let row = treeView.selectedRow
        
        if let item = treeView.item(atRow: row) {
            
            let pItem = treeView.parent(forItem: item)
            
            if let callback = self.selectionChangedCallback {

                  callback(item as AnyObject, pItem as AnyObject?)
            }
        }
    }
}


extension TreeViewDataDelegate: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        let rootNode:TreeNodeModel
        
        if item != nil {
            rootNode = item as! TreeNodeModel
        }
        else {
            rootNode =  self.treeNodes
        }
        return rootNode.childNodes.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        let rootNode:TreeNodeModel
        
        if item != nil {
            rootNode = item as! TreeNodeModel
        }
        else {
            rootNode =  self.treeNodes
        }
        return rootNode.childNodes[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let rootNode:TreeNodeModel = item as! TreeNodeModel
        return rootNode.childNodes.count > 0
    }
    
    
    func  outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        return .every
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        let pboard = info.draggingPasteboard()
        self.handleFileBasedDrops(pboard)
        return true
    }
    
    func handleFileBasedDrops(_ pboard: NSPasteboard ) {
        let fileURLType = NSPasteboard.PasteboardType.backwardsCompatibleFileURL
        if (pboard.types?.contains(fileURLType))! {
            var filePath: String?
            if #available(OSX 10.13, *) {
                if let utTypeFilePath = pboard.propertyList(forType:fileURLType) as? URL {
                    filePath = utTypeFilePath.path
                }
            }
            else {
                // UTType 类型的文件路径，需要转换成标准路径
                if let utTypeFilePath = pboard.string(forType:fileURLType) {
                    filePath =  URL(fileURLWithPath: utTypeFilePath).standardized.path
                }
            }
            //代理通知
            if let dragFileCallBack = self.dragFileCallBack, let filePath = filePath {
                dragFileCallBack(filePath)
            }
        }
    }
    
}


