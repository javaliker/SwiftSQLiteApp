//
//  Config.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/7.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

class Config: NSObject {
   
    private static let  sharedInstance = Config()
    class var shared: Config {
        return sharedInstance
    }
    
    lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "macdec.io.SQLiteApp")
        return queue
    }()
    
    lazy var main: DispatchQueue = {
        let queue = DispatchQueue.main
        return queue
    }()
    
}
