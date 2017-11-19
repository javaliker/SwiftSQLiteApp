//
//  AppMainWindowController.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

import Cocoa

let kHomeURL = "http://www.macdev.io"

class AppMainWindowController: NSWindowController {
    
    lazy var splitViewController: AppMainSplitViewController = {
        let vc = AppMainSplitViewController()
        return vc
    }()
    
    var openFileDlg = NSOpenPanel()
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.configWindowStyle()
        self.setWindowTitleImage()
        self.contentViewController = self.splitViewController
    }
    
    func configWindowStyle() {
        //Toolbar 跟titleBar 融合在一起显示
        self.window?.titleVisibility = .hidden;
        //透明化
        //self.window?.titlebarAppearsTransparent = true
        //设置背景颜色
        //self.window?.backgroundColor = NSColor.red
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("AppMainWindowController")
    }
    
    func setWindowTitleImage(){
        self.window?.representedURL = URL(string:"WindowTitle")
        self.window?.title = "SQLiteApp"
        let image = NSImage(named: NSImage.Name(rawValue: "windowIcon"))
        self.window?.standardWindowButton(.documentIconButton)?.image = image
    }
    
    //MARK: Toolbar Action
    
    @IBAction func openDBActionClicked(_ sender: AnyObject) {
        
        openFileDlg.canChooseFiles = true
        openFileDlg.canChooseDirectories = false
        openFileDlg.allowsMultipleSelection = false
        openFileDlg.allowedFileTypes = ["sqlite"]
        
        openFileDlg.begin(completionHandler: { [weak self] result in
            
            if(result.rawValue == NSFileHandlingPanelOKButton){
                
                let fileURLs = self?.openFileDlg.urls
                
                for url: URL in fileURLs!  {
                    
                    NotificationCenter.default.post(name:Notification.Name.onOpenDBFile, object: url.path)
                    
                    break
                }
            }
        })
    }
    
    
    @IBAction func closeDBActionClicked(_ sender: AnyObject) {
        
        let alert = NSAlert()
        //增加OK按钮
        alert.addButton(withTitle: "Ok")
        
        //增加Cancel按钮
        alert.addButton(withTitle: "Cancel")
        
        //提示的标题
        alert.messageText = "Confirm"
        //提示的详细内容
        alert.informativeText = "Close Database?"
        //设置告警风格
        alert.alertStyle = .informational
        alert.beginSheetModal(for: self.window!, completionHandler: { returnCode in
               //当有多个按钮是 可以通过returnCode区分判断
               if returnCode == NSApplication.ModalResponse.alertFirstButtonReturn {
                
                    NotificationCenter.default.post(name:Notification.Name.onCloseDBFile, object: nil)
                
               }
            }
        )
    }
    
    @IBAction func homeToolBarClicked(_ sender: AnyObject) {
        
        let url = URL(string: kHomeURL)
        
        if !NSWorkspace.shared.open(url!) {
            print("open failed!")
        }
    }
}

extension Notification.Name {
    //定义消息通知名称
    static let onOpenDBFile  = Notification.Name("on-open-file")
    static let onCloseDBFile = Notification.Name("on-close-file")
}
