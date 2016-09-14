//
//  TreeViewDataDelegate.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/5.
//  Copyright © 2016年 macdev. All rights reserved.
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
        
        let view = outlineView.make(withIdentifier: (tableColumn?.identifier)!, owner: self)
        let subviews  = view?.subviews
        //let imageView = subviews?[0] as! NSImageView
        
        let field = subviews?[1] as! NSTextField
        let model = item as! TreeNodeModel
        
        field.stringValue = model.name
        
//        if model.childNodes.count <= 0 {
//            imageView.image = NSImage(named: NSImageNameListViewTemplate)
//        }
        
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
}

