//
//  DataPageManager.swift
//  TableViewControllerDemo
//
//  Created by iDevFans on 16/8/20.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Foundation



public protocol PaginatorDelegate: class {
    func paginator(id:AnyObject , pageIndex index:Int, pageSize size:Int )
    func totalNumberOfData(_ id:AnyObject) ->Int
}

class DataPageManager : NSObject {
    
    weak var delegate: PaginatorDelegate?
    var page: Int = 0
    var pageSize: Int = 0
    var pages: Int = 0
    var total: Int = 0

    convenience init(pageSize: Int , delegate paginatorDelegate: PaginatorDelegate? ) {
        self.init()
        self.pageSize = pageSize
        self.delegate = paginatorDelegate
    }
    
    convenience init(pageSize: Int ) {
        self.init(pageSize: pageSize , delegate: nil)
    }
    
    func isFirstPage() ->Bool {
        return self.page == 0
    }
    
    func isLastPage() ->Bool {
        return (self.pages == 0 || self.page == self.pages-1)
    }
    
    func goPage(_ index:Int) {
        if self.pages > 0 && index <= self.pages-1 {
            self.page = index
           
            if let paginatorDelegate = self.delegate {
                paginatorDelegate.paginator(id: self, pageIndex: index, pageSize: self.pageSize)
            }
        }
    }
  
    func refreshCurrentPage() {
         self.goPage(self.page)
    }
    
    func refreshCurrentPage(complete: (()->Void)? ) {
        self.goPage(self.page)
        if let callback = complete {
            let deadlineTime = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                callback()
            }
        }
    }
    
    func goNextPage(){
        if !self.isLastPage() {
            self.goPage(self.page+1)
        }
    }
    
    func goPrePage() {
        if !self.isFirstPage() {
             self.goPage(self.page-1)
        }
    }
    
    func goFirstPage(){
         self.goPage(0)
    }
    
    func goLastPage() {
        if self.pages > 1 {
            return self.goPage(self.pages-1)
        }
    }
    
    func reset() {
        self.pages = 0
        self.page = 0
    }

    func computePageNumbers() {
        self.reset()
        if let paginatorDelegate = self.delegate {
            self.total = paginatorDelegate.totalNumberOfData(self)
            if self.pageSize > 0 {
                self.pages = Int(ceil( Double(self.total)  / Double(self.pageSize)))
            }
            else{
                self.pages = 0
            }
        }
    }
}


