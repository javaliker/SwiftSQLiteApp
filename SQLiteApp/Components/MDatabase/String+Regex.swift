//
//  String+Regex.swift
//  LocalizationTools
//
//  Created by iDevFans on 16/8/28.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa
import Foundation

extension String {
    
    func matchedSQLTableName() -> String? {
        let pattern = ".*\\s+from\\s+(\\w+).*"
        let matched = self.matches(pattern: pattern)
        if matched.count > 1 {
            return matched[1]
        }
        return nil
    }
    
    func matches(pattern: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSMakeRange(0, nsString.length))
            
            var match = [String]()
            for result in results {
                for i in 0..<result.numberOfRanges {
                  match.append(nsString.substring(with:result.range(at: i) ))
                }
            }
            return match
            //return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}
