//
//  AppDelegate.swift
//  WritingBlock
//
//  Created by Robert Sikorski on 2/19/16.
//  Copyright © 2016 Robert Sikorski. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let preferences = UserDefaults.standard
        let savedFilePath = preferences.url(forKey: "currentDocumentPath")
        if savedFilePath != nil && !FileManager.default.fileExists(atPath: savedFilePath!.path) {
            preferences.set(nil, forKey: "currentDocumentPath")
        } else {
            //
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
