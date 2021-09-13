//
//  MainWindow.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 16.06.2020.
//  Copyright © 2020 Pavel Morozov. All rights reserved.
//

import Cocoa

class MainWindow: NSPanel {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        self.isFloatingPanel = true
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            self.close()
        }
    }
}
