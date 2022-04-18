//
//  PaddedTextField.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 17.06.2020.
//  Copyright © 2020 Pavel Morozov. All rights reserved.
//

import Cocoa

class PaddedTextFieldCell: NSTextFieldCell {
    private static let padding = CGSize(width: 10.0, height: 10.0)
    
    override func cellSize(forBounds rect: NSRect) -> NSSize {
        var size = super.cellSize(forBounds: rect)
        size.height += (PaddedTextFieldCell.padding.height * 2)
        return size
    }
    
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        return rect.insetBy(dx: PaddedTextFieldCell.padding.width, dy: PaddedTextFieldCell.padding.height)
    }
    
    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        let insetRect = rect.insetBy(dx: PaddedTextFieldCell.padding.width, dy: PaddedTextFieldCell.padding.height)
        super.edit(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, event: event)
    }
    
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        let insetRect = rect.insetBy(dx: PaddedTextFieldCell.padding.width, dy: PaddedTextFieldCell.padding.height)
        super.select(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        let insetRect = cellFrame.insetBy(dx: PaddedTextFieldCell.padding.width, dy: PaddedTextFieldCell.padding.height)
        super.drawInterior(withFrame: insetRect, in: controlView)
    }
}
