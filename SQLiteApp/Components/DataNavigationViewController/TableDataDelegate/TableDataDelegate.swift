//
//  TableDataDelegate.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/20.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa



//选择不同的行回调接口
typealias SelectionChangedCallbackBlock =  (_ index:NSInteger ,  _ obj: AnyObject) -> ()
//拖放Drag/Drop回调接口
typealias TableViewRowDragCallbackBlock =  (_ sourceRow:NSInteger , _ targetRow: NSInteger) -> ()
//修改单元格值变化时回调接口
typealias RowObjectValueChangedCallbackBlock =  (_ obj: AnyObject , _ oldObj: AnyObject ,  _  row: NSInteger ,  _  fieldName: String ) -> ()


let kTableViewDragDataTypeName  = "TableViewDragDataTypeName"

class TableDataDelegate: NSObject {
    weak var owner: NSTableView?
    var selectionChangedCallback: SelectionChangedCallbackBlock?
    var rowDragCallback: TableViewRowDragCallbackBlock?
    var rowObjectValueChangedCallback: RowObjectValueChangedCallbackBlock?
    var items  = [AnyObject]()
    
    func setData(data: AnyObject?) {
        if let aData = data {
            self.clearData()
            if aData is [AnyObject] {
                self.items = aData as! [AnyObject]
            }
        }
    }
    
    func updateData(data: AnyObject?, row: NSInteger) {
        
        if row <= items.count - 1 {
            self.items[row] = data!
        }
    }
    
    func addData(data: AnyObject?) {
        if let aData = data {
            if aData is [AnyObject] {
                self.items.append(contentsOf: aData as! [AnyObject])
            }
            else {
                self.items.append(aData)
            }
            
        }
    }
    
    
    func addData(data: AnyObject? , at Index: NSInteger) {
        if let aData = data {
            self.items.insert(aData, at: Index)
        }
    }
    
    func deleteData(data: Any) {
        if data is IndexSet {
            let indexSet = data as! IndexSet
            let mutuDatas = NSMutableArray(array: self.items)
            mutuDatas.removeObjects(at: indexSet)
            self.items = mutuDatas as [AnyObject]
        }
        else  if data is  [AnyObject] {
            let datas = data as! [AnyObject]
            let mutuDatas = NSMutableArray(array: self.items)
            for obj in datas {
                mutuDatas.remove(obj)
            }
            self.items = mutuDatas as [AnyObject]
        }
        else {
            let mutuDatas = NSMutableArray(array: self.items)
            mutuDatas.remove(data)
            self.items = mutuDatas as [AnyObject]
        }
    }
    
    func deleteDataAt(index: Int) {
        self.items.remove(at: index)
    }
    
    func deleteDataAt(indexSet: IndexSet) {
        self.deleteData(data: indexSet)
    }
    
    func insertObject(anObject: AnyObject, at Index: NSInteger ) {
        self.addData(data: anObject, at: Index)
    }
    
    func exchangeObjectAt(idx1: Int, idx2: Int ) {
        
        if idx1 >= self.items.count - 1 {
            return
        }
        if idx2 >= self.items.count - 1 {
            return
        }
        
        let mutuDatas = NSMutableArray(array: self.items)
        mutuDatas.exchangeObject(at: idx1, withObjectAt: idx2)
        self.items = mutuDatas as [AnyObject]
    }
    
    func clearData() {
        self.items = [AnyObject]()
    }
    
    func itemCount() ->NSInteger {
        return self.items.count
    }
    
    func itemOf(row: NSInteger) ->AnyObject? {
        
        if row < 0 || row >= self.items.count {
            return nil
        }
        return self.items[row]
    }
    
    func itemOf(indexSet: IndexSet) ->[AnyObject]? {
        if  self.items.count <= 0 {
            return nil
        }
        var retData = [AnyObject]()
        for idx in indexSet {
            let obj = self.items[idx]
            retData.append(obj)
        }
        return retData
    }
}


extension TableDataDelegate: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.items.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        let tableView = notification.object as! NSTableView
        let row = tableView.selectedRow
        
        if row < 0 || row >= self.items.count {
            return
        }
        
        let data = self.items[row]
        
        if let callback = selectionChangedCallback {
            callback(row,data)
        }
        
       
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        
        let sortDescriptors = tableView.sortDescriptors
        let mutuDatas = NSMutableArray(array: self.items)
        let sortData = mutuDatas.sortedArray(using: sortDescriptors)
        self.items = sortData as [AnyObject]
        tableView.reloadData()
    }
    
    
    // MARK: Drag&Drop
    
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        
        let zNSIndexSetData = NSKeyedArchiver.archivedData(withRootObject: rowIndexes);
        pboard.declareTypes([kTableViewDragDataTypeName], owner: self)
        pboard.setData(zNSIndexSetData, forType: kTableViewDragDataTypeName)
        return true
    }
    
    //允许拖放
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        return .every
    }
    
    
    //拖放结束后,从剪切板对象获取到拖放的dragRow.
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        
        let pboard = info.draggingPasteboard()
        let rowData = pboard.data(forType: kTableViewDragDataTypeName)
        let rowIndexes = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! NSIndexSet
        let dragRow = rowIndexes.firstIndex
        
        
        let temp = self.items[row]
        self.items[row] = self.items[dragRow]
        self.items[dragRow] = temp
        
        tableView.reloadData()
        
        return true
    }
}

extension TableDataDelegate: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let data = self.items[row]
        //表格列的标识
        let identifier = (tableColumn?.identifier)!
        //单元格数据
        let value = data.value(forKey: identifier)
        
        //根据表格列的标识,创建单元视图
        var view = tableView.make(withIdentifier: identifier, owner: self)
        
        let tableColumnItem = tableView.xx_columnItemWithIdentifier(identifier)!
        
            switch (tableColumnItem.cellType) {
                
            case .checkBox:
                
                var  checkBoxField: NSButton?
                //如果不存在,创建新的checkBoxField
                if view == nil {
                    checkBoxField = NSButton.init(item: tableColumnItem)
                    view = checkBoxField
                    view?.identifier = identifier
                }
                else{
                    checkBoxField = view as? NSButton
                }
                
                checkBoxField?.target = self
                checkBoxField?.action = #selector(TableDataDelegate.checkBoxChick(_:))
                
                if let state  = value {
                    if state is NSNumber {
                        checkBoxField?.state = state as! NSInteger
                    }
                    
                }
                
                break

            case .comboBox:
                
                var comboBoxField: NSComboBox?
            
                if view == nil {

                    view = NSTableCellView()
                    view?.identifier = identifier
                    comboBoxField =  NSComboBox.init(item: tableColumnItem)
                    comboBoxField?.delegate = self
                    comboBoxField?.translatesAutoresizingMaskIntoConstraints = false
                    view?.addSubview(comboBoxField!)
                    
                    
                    let left = comboBoxField?.leftAnchor.constraint(equalTo: (view?.leftAnchor)!, constant: 0)
                    let right = comboBoxField?.rightAnchor.constraint(equalTo: (view?.rightAnchor)!, constant: 0)
                    
                    let centerY = comboBoxField?.centerYAnchor.constraint(equalTo: (view?.centerYAnchor)!, constant: 0)
                    NSLayoutConstraint.activate([left!, right!, centerY!])

                }
                else{
                    comboBoxField = view?.subviews[0] as? NSComboBox
                }
                
                let items = tableColumnItem.items
                if let values = items {
                    comboBoxField?.addItems(withObjectValues: values)
                }
                
                if let text  = value {
                    
                    if text is String {
                       comboBoxField?.stringValue = text as! String
                    }
                    
                    
                }
                
                break
                
                
            case .imageView:
                
                
                
                var imageField: NSImageView?
                //如果不存在,创建新的textField
                 if view == nil {
                    imageField =  NSImageView.init(item: tableColumnItem)
                    view = imageField
                    view?.identifier = identifier
                }
                else{
                    imageField = view as? NSImageView
                }
                
                if let image  = value {
                    //更新单元格的image
                    imageField?.image = image as? NSImage
                }

                
                break
                
            default:
    
                    var  textField: NSTextField?
                    //如果不存在,创建新的textField
                    if view == nil {
                        textField = NSTextField.init(item: tableColumnItem)
                        textField?.delegate  = self
                        view = textField
                        view?.identifier = identifier
                    }
                    else{
                        textField = view as? NSTextField
                    }
                    
                    textField?.stringValue  = ""
                    if let text  = value {
                        //更新单元格的文本
                       
                        if text is String {
                            textField?.stringValue = text as! String
                        }
                        if text is NSNumber {
                            let num = text as! NSNumber
                            textField?.stringValue = num.stringValue
                        }
                        
                    }
                
                break
                
            }
        
        return view

    }
    
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
        return 24
    }
    
    
    @IBAction func checkBoxChick(_ sender:NSButton) {
        let identifier = sender.identifier
        let rowIndex = self.owner?.selectedRow
        
        
        if let data = self.itemOf(row: rowIndex!) {
            
            //老数据的copy
            let oldData = data
            //更新数据源
            
            data.setValue(NSNumber.init(value:  sender.state), forKey: identifier!)
            
            
            self.updateData(data: data, row: rowIndex!)
            //数据变化回调通知
            if let callback = rowObjectValueChangedCallback {
                callback(data, oldData, rowIndex!, identifier!)
            }
        }

    
    }
}

extension TableDataDelegate: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        
        let field = obj.object as! NSTextField
        
        let identifier = field.identifier
        let rowIndex = self.owner?.selectedRow
        var data = self.itemOf(row: rowIndex!) as! Dictionary<String,Any>
        //老数据的copy
        let oldData = data
        //更新数据源
        data[identifier!] = field.stringValue
        self.updateData(data: data as AnyObject?, row: rowIndex!)
        
        //数据变化回调通知
        if let callback = rowObjectValueChangedCallback {
            callback(data as AnyObject, oldData as AnyObject, rowIndex!, identifier!)
        }
    }
}


extension TableDataDelegate: NSComboBoxDelegate {
    func comboBoxSelectionDidChange(_ notification: Notification) {
        let field = notification.object as! NSComboBox
        let identifier = field.identifier
        let rowIndex = self.owner?.selectedRow
        var data = self.itemOf(row: rowIndex!) as!  Dictionary<String,Any>
        //老数据的copy
        let oldData = data
        //更新数据源
        let indexOfSelectedItem = field.indexOfSelectedItem
        let type = field.itemObjectValue(at: indexOfSelectedItem)
        data[identifier!] = type 
        
        self.updateData(data: data as AnyObject?, row: rowIndex!)
        
        //数据变化回调通知
        if let callback = rowObjectValueChangedCallback {
            callback(data as AnyObject, oldData as AnyObject, rowIndex!, identifier!)
        }
    }
}







