//
//  Screen.swift
//  ClipboardManager
//
//  Created by Pavel on 28.12.2021.
//  Copyright © 2021 Pavel Morozov. All rights reserved.
//

import Foundation
import AppKit

extension NSScreen {
    /// Текущий активный экран (тот на котором находится курсор)
    /// - Returns: NSScreen
    static func getActive() -> NSScreen {
        var screenIndex = 0
        for (index, screen) in NSScreen.screens.enumerated() {
            if screen.frame.contains(NSEvent.mouseLocation) {
                screenIndex = index
                break
            }
        }
        return NSScreen.screens[screenIndex]
    }
}
