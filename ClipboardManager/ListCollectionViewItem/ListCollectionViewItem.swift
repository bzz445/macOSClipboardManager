//
//  ListCollectionViewItem.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 17.06.2020.
//  Copyright © 2020 Pavel Morozov. All rights reserved.
//

import Cocoa

class ListCollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var textLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    }
    
    override var isSelected: Bool {
        didSet {
            if #available(macOS 10.14, *) {
                self.view.layer?.backgroundColor = (isSelected ? NSColor.controlAccentColor.cgColor : NSColor.clear.cgColor)
            } else {
                self.view.layer?.backgroundColor = (isSelected ? NSColor.systemGray.cgColor : NSColor.clear.cgColor)
            }
            self.textLabel.textColor = isSelected ? NSColor.selectedMenuItemTextColor : NSColor.controlTextColor
        }
    }
}
