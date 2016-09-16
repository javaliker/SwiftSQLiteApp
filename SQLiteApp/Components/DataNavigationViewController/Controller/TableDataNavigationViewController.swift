//
//  TableDataNavigationViewController.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/21.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//


import Cocoa
let kPageSize: Int = 20
class TableDataNavigationViewController: XibViewController {

    lazy var pageManager: DataPageManager = {
        let dataPageManager = DataPageManager.init(pageSize: kPageSize)
        return dataPageManager
    }()
    
    deinit {
        self.tableView?.unregisterDraggedTypes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //自动布局
        self.setupAutolayout()

        //配置表格样式
        self.tableViewStyleConfig()
        //设置表格代理
        self.tableDelegateConfig()
        
        //配置表格列
        self.tableViewColumnConfig()

         //关联导航面板按钮事件
        self.dataNavigationView?.target = self
        self.dataNavigationView?.action = #selector(self.toolButtonClicked(_:))
        //配置导航面板的按钮
        self.dataNavigationView?.setUpNavigationViewWithItems(self.dataNavigationItemsConfig())
    
        //注册拖放
        self.registerRowDrag()
        
    }
    
    
    func setupAutolayout() {
        //如果存在xib，则说明不需要通过代码设置自动布局
        if self.tableXibView() != nil {
            return
        }
        
        //关联表视图到滚动条视图
        self.tableViewScrollView?.documentView = self.tableView
        //将滚动条视图添加到父视图
        self.view.addSubview(self.tableViewScrollView!);
        
        //将导航面板视图添加到父视图
        self.view.addSubview(self.dataNavigationView!);

        //表格视图自动布局配置
        {
            let top = self.tableViewScrollView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
            let bottom = self.tableViewScrollView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            
            let left = self.tableViewScrollView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
            let right = self.tableViewScrollView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
            
            //激活自动布局约束
            NSLayoutConstraint.activate([left!, right!,top!, bottom! ])
            
        }();
        
        //底部导航视图自动布局配置
        {
            let top = self.dataNavigationView?.topAnchor.constraint(equalTo: (self.tableViewScrollView?.bottomAnchor)!, constant: 0)
            let bottom = self.dataNavigationView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            
            let left = self.dataNavigationView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
            let right = self.dataNavigationView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
            
            //激活自动布局约束
            NSLayoutConstraint.activate([left!, right!,top!, bottom! ])
        
        }()
    }
    
    func tableViewColumnConfig(){
        let items = self.tableColumnItems()
        self.tableView?.xx_updateColumnsWithItems(items)
    }

    func tableColumnItems() ->[TableColumnItem] {
        return [TableColumnItem]()
    }
    
    func tableViewStyleConfig() {
        self.tableView?.gridStyleMask = [.solidHorizontalGridLineMask,.solidVerticalGridLineMask ]
        self.tableView?.usesAlternatingRowBackgroundColors = true
    }
    
    func tableDelegateConfig() {
        // subclass override this in subclass
    }

    
    func registerRowDrag() {
        self.tableView?.register(forDraggedTypes: [kTableViewDragDataTypeName])
    }

    // MARK: Action
    
    @IBAction func toolButtonClicked(_ sender: NSButton) {
        let actionType = DataNavigationViewButtonActionType(rawValue: sender.tag)!
        
        switch (actionType) {
       
        case .add:
            self.addNewData()
            break
            
        case .remove:
            self.reomoveSelectedData()
            break
            
        case .refresh:
            self.pageManager.refreshCurrentPage()
            break
           
        case .first:
            self.pageManager.goFirstPage()
            break
            
        case .pre:
            self.pageManager.goPrePage()
            break
            
        case .next:
            self.pageManager.goNextPage()
            break
            
        case .last:
            self.pageManager.goLastPage()
            break
        }
        
    }
    
    func addNewData() {
        
    }
   
    func reomoveSelectedData() {
        let selectedRow = self.tableView?.selectedRow
        //没有行选择,不执行删除操作
        if selectedRow! < 0 {
            return
        }
        //开始删除
        self.tableView?.beginUpdates()
        let indexes = self.tableView?.selectedRowIndexes
        //以指定的动画风格执行删除
        self.tableView?.removeRows(at: indexes!, withAnimation: .slideUp)
        //完成删除
        self.tableView?.endUpdates()
    }

    
    // MARK: NavigationView Config
    
    func dataNavigationItemsConfig() -> [DataNavigationItem] {
        let insertItem = DataNavigationButtonItem()
        insertItem.imageName = NSImageNameAddTemplate
        insertItem.tooltips = "insert a row into current table"
        insertItem.tag = .add
        
        let deleteItem = DataNavigationButtonItem()
        deleteItem.imageName = NSImageNameRemoveTemplate
        deleteItem.tooltips = "delete seleted rows form current table"
        deleteItem.tag = .remove
        
        let refreshItem = DataNavigationButtonItem()
        refreshItem.imageName = NSImageNameRefreshTemplate
        refreshItem.tooltips = "reload table data"
        refreshItem.tag = .refresh
        
        let flexibleItem = DataNavigationFlexibleItem()
        
        
        let firstItem = DataNavigationButtonItem()
        firstItem.imageName = kToolbarFirstImageName
        firstItem.tooltips = "go first page"
        firstItem.tag = .first
        
        let preItem = DataNavigationButtonItem()
        preItem.imageName = kToolbarPreImageName
        preItem.tooltips = "go pre page"
        preItem.tag = .pre
        
        let pageLable = DataNavigationTextItem()
        pageLable.identifier = kPagesIdentifier
        pageLable.title = "0/0"
        pageLable.alignment = .center
        
        
        let nextItem = DataNavigationButtonItem()
        nextItem.imageName = kToolbarNextImageName
        nextItem.tooltips = "go next page"
        nextItem.tag = .next
        
        let lastItem = DataNavigationButtonItem()
        lastItem.imageName = kToolbarLastImageName
        lastItem.tooltips = "go last page"
        lastItem.tag = .last
        
        
        return [insertItem,deleteItem,refreshItem,flexibleItem,firstItem,preItem,pageLable,nextItem,lastItem]
    }
    
    
    func tableViewSortColumnsConfig() {
        
        for tableColumn in (self.tableView?.tableColumns)! {
            //升序排序
            
            //使用系统的排序方法
            let  sortDescriptor =  NSSortDescriptor(key: tableColumn.identifier, ascending: true,
                                                   selector: #selector(NSNumber.compare(_:)))
            
            //使用自定义的排序方法
            let sortRules = NSSortDescriptor(key: tableColumn.identifier, ascending: true, comparator:{ s1,s2 in
                    let str1 = s1 as! String
                    let str2 = s2 as! String
                    if str1 > str2 {return .orderedAscending}
                    if str1 < str2 {return .orderedDescending}
                    return .orderedSame
                }
            )
            
            //image列暂不排序
            if tableColumn.identifier != "image" {
                tableColumn.sortDescriptorPrototype = sortDescriptor
            }
        }
    }
    
    // MARK : Page 
    
    func computePageNumbers () {
        return self.pageManager.computePageNumbers()
    }
    
    func updatePageInfo() {
        let currentPageIndex = self.pageManager.page
        let pageNumbers = self.pageManager.pages
        var pageInfo: String?
        if pageNumbers > 0 {
            pageInfo = "\(currentPageIndex+1)/\(pageNumbers)"
        }
        else {
            pageInfo = "\(currentPageIndex)/\(pageNumbers)"
        }
        
        self.dataNavigationView?.updatePagesLabel(title: pageInfo!)
        let info = "\(self.pageManager.total) records"
        self.dataNavigationView?.updateInfoLabel(title: info)
    }
    
  
    // MARK: ivars
    
    func tableViewXibScrollView() ->NSScrollView? {
        return nil
    }

    func tableXibView() ->NSTableView? {
        return nil
    }
    
    func dataNavigationXibView() ->DataNavigationView? {
        return nil
    }
    
    
    lazy var tableView: NSTableView? = {
        var tb: NSTableView?  = self.tableXibView()
        if tb == nil {
            tb = NSTableView()
            tb?.focusRingType = .none
            tb?.autoresizesSubviews = true
        }
        return tb
    }()
    
    lazy var tableViewScrollView: NSScrollView? = {
        
        var tbScollView: NSScrollView? = self.tableViewXibScrollView()
        if tbScollView == nil {
            tbScollView = NSScrollView()
            tbScollView?.hasVerticalScroller = false
            tbScollView?.hasVerticalScroller = false
            tbScollView?.focusRingType = .none
            tbScollView?.autohidesScrollers = true
            tbScollView?.borderType = .noBorder
            tbScollView?.translatesAutoresizingMaskIntoConstraints = false
        }
        return tbScollView
    }()
    
    lazy var dataNavigationView: DataNavigationView? = {
        
        var dataNav: DataNavigationView? = self.dataNavigationXibView()
        if dataNav == nil {
            dataNav = DataNavigationView()
            dataNav?.translatesAutoresizingMaskIntoConstraints = false
        }
        return dataNav
    }()
}


