//
//  JSONKit.swift
//  OpenMacX
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Foundation

import Foundation

extension String {
    
    func jsonObject() -> [String:Any]? {
        let jsonData = self.data(using: String.Encoding.utf8)!
        return jsonData.jsonObject()
    }
    
}

extension Array {
    
    func jsonData() ->Data? {
        let data = try? JSONSerialization.data(withJSONObject: self , options: [.prettyPrinted])
        return data
    }
    
    func jsonString() ->String? {
        var string: String?
        if let data = self.jsonData(){
            string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }
        return string
    }
    
}

extension Dictionary {
    
    func jsonData() ->Data? {
        let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
        return data
    }
    
    func jsonString() ->String? {
        var string: String?
        if let data = self.jsonData(){
            string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }
        return string
    }
}

extension Data {
    
    func jsonObject() -> [String:Any]? {
        let jsonDict = try? JSONSerialization.jsonObject(with: self, options: [.allowFragments])
        return jsonDict as? Dictionary<String,Any>
    }
    
}
