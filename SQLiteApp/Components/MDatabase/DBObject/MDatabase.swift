//
//  MDatabase.swift
//  MDatabase
//
//  Created by iDevFans on 16/8/28.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

class MDatabase: NSObject {
    var queue: FMDatabaseQueue!
    var dbName = ""
    var dbPath: URL?
    
    deinit {
        self.close()
    }
    
    private static let  sharedInstance = MDatabase()
    class var shared: MDatabase {
        return sharedInstance
    }
    
    func openDBWithName(dbName: String) -> Bool {
        self.dbName = dbName
        let dbPath  =  URL(fileURLWithPath: self.docPath()).appendingPathComponent(dbName)
        return self.openDBWithPath(dbPath: dbPath)
    }
    
    func openDBWithPath(dbPath: URL) -> Bool {
        let fileManager = FileManager.default
        
        let success = fileManager.fileExists(atPath: dbPath.path)
        if !success {
            let resourcePath = Bundle.main.resourcePath!
            let defaultDBPath =  URL(fileURLWithPath: resourcePath).appendingPathComponent(self.dbName)
            
            do {
                try fileManager.copyItem(at: defaultDBPath, to: dbPath)
            }
            catch let error {
                print("copy path \(dbPath.path) error \(error)")
            }
          
        }
        self.dbPath = dbPath
        self.queue = FMDatabaseQueue(path: dbPath.path)
        if (self.queue == nil) {
            print("\n create queue failed!")
            return false
        }
        return true
    }
    
    func close() {
        if (self.queue != nil) {
            self.queue.close()
            self.queue = nil
        }
    }
    
    func docPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
}
