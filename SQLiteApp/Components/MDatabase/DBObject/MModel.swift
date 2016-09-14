//
//  MModel.swift
//  MDatabase
//
//  Created by iDevFans on 16/8/28.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

class MModel: NSObject {
    
    
    override required init() {
        super.init()
    }
    
    lazy var dao: MDAO = {
        print("\(type(of: self))")
        print("\(self.className)")
        let className = "\(self.className)DAO"
        let aClass = NSClassFromString(className) as! MDAO.Type
        return aClass.init()

    }()
    
    func save() {
        _ = self.dao.insert(model: self)
    }
    
    func update() {
        _ = self.dao.update(model: self)
    }
    
    func delete() {
        _ = self.dao.delete(model: self)
    }
}
