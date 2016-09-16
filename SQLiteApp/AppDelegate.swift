//
//  AppDelegate.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/7.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var preferencesWindowController: PreferencesWindowController  = {
        let sb = NSStoryboard(name: "Main", bundle: Bundle.main)
        let pWVC = sb.instantiateController(withIdentifier: "Preferences") as! PreferencesWindowController
        return pWVC
    }()
    
    
    @IBAction func showPreferenceWindowController(_ sender: AnyObject) {
        self.preferencesWindowController.showWindow(self)
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("applicationDidFinishLaunching")
    }


}

