//
//  AppDelegate.swift
//  Launcher
//
//  Created by Pavel on 13.12.2021.
//  Copyright © 2021 Pavel Morozov. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == AppParams.mainBundleName }.isEmpty

        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: AppParams.killLauncherNotificationName, object: AppParams.mainBundleName)


            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast(3)
            components.append("MacOS")
            components.append(AppParams.mainProductId)
            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared.launchApplication(newPath)
        }
        else {
            terminate()
        }
    }
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

