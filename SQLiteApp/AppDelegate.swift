//
//  AppDelegate.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/7.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var mainWindowController: AppMainWindowController = {
        let mainWVC = AppMainWindowController()
        return mainWVC
    }()
    
    
    lazy var preferencesWindowController: PreferencesWindowController  = {
        let sb = NSStoryboard(name: "Main", bundle: Bundle.main)
        let pWVC = sb.instantiateController(withIdentifier: "Preferences") as! PreferencesWindowController
        // or whichever bundle
        return pWVC
    }()
    
    
    @IBAction func showPreferenceWindowController(_ sender: AnyObject) {
        
        self.preferencesWindowController.showWindow(self)
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        //self.mainWindowController.showWindow(self)
    }



}

