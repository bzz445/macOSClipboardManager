//
//  AboutViewController.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 06.09.2021.
//

import Cocoa

class AboutViewController: NSViewController {
    @IBOutlet weak var appNameLabel: NSTextField!
    @IBOutlet weak var appVersionLabel: NSTextField!
    @IBOutlet weak var appCopyrightLabel: NSTextField!
    @IBOutlet weak var appIconImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appIconImageView.image = NSApp.applicationIconImage
        if let infoDictionary = Bundle.main.infoDictionary {
            appNameLabel.stringValue = infoDictionary["CFBundleName"] as? String ?? ""
            let version = infoDictionary["CFBundleShortVersionString"] as? String ?? ""
            let build = infoDictionary["CFBundleVersion"] as? String ?? ""
            appVersionLabel.stringValue = "version \(version) (\(build))"
            appCopyrightLabel.stringValue = infoDictionary["NSHumanReadableCopyright"] as? String ?? ""
        }
    }
}
