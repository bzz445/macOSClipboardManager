//
//  ViewController.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 16.06.2020.
//  Copyright © 2020 Pavel Morozov. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    @IBOutlet weak var searchTextField: NSTextField!
    @IBOutlet weak var listCollectionView: NSCollectionView!
    
    var list: [String] = []
    var searchResult: [String] = []
    let listCollectionViewDelegate = ListCollectionViewDelegateHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupListCollectionView()
        self.searchTextField.delegate = self
        
        self.watchPasteboard { (string) in
            self.list.append(string)
            UserDefaults.standard.set(self.list, forKey: "data")
        }
    }
    
    override func viewWillAppear() {
        self.loadList()
        self.searchTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear() {

    }
    
    override var representedObject: Any? {
        didSet {

        }
    }
    
    @IBAction func searchTextFieldAction(_ sender: Any) {

    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: "data")
    }
    
    func loadList() {
        self.list = UserDefaults.standard.stringArray(forKey: "data")?.reversed() ?? []
        self.searchResult = self.list
        self.listCollectionViewDelegate.data = self.searchResult
        self.listCollectionView.reloadData()
    }
    
    func setupListCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: self.listCollectionView.frame.size.width, height: 30.0)
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.minimumLineSpacing = 1.0
        self.listCollectionView.isSelectable = true
        self.listCollectionView.allowsEmptySelection = true
        self.listCollectionView.allowsMultipleSelection = false
        self.listCollectionView.collectionViewLayout = flowLayout
        self.listCollectionView.register(NSNib(nibNamed: "ListCollectionViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ListCollectionViewItem"))
        self.listCollectionView.dataSource = self.listCollectionViewDelegate
        self.listCollectionView.delegate = self.listCollectionViewDelegate
        self.listCollectionViewDelegate.didSelectBlock = { [weak self] string in
            self?.copyToClipBoard(string: string)
            self?.searchTextField.becomeFirstResponder()
            NSApplication.shared.windows.last?.close()
        }
    }
    
    func moveSelectedItem(next: Bool) {
        var selectedItem = self.listCollectionView.selectionIndexPaths.first?.item ?? -1
        if next {
            selectedItem += 1
        } else {
            selectedItem -= 1
        }
        if selectedItem < self.searchResult.count && selectedItem >= 0 {
            self.listCollectionView.deselectAll(nil)
            self.listCollectionView.selectItems(at: [IndexPath(item: selectedItem, section: 0)], scrollPosition: NSCollectionView.ScrollPosition.centeredVertically)
        }
    }
    
    func copyToClipBoard(string: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(string, forType: .string)
    }
    
    func copyTo() {
        let selectedItem = self.listCollectionView.selectionIndexPaths.first?.item ?? -1
        if selectedItem == -1 {
            return
        }
        copyToClipBoard(string: self.searchResult[selectedItem])
        
    }
    
    func watchPasteboard(copied: @escaping (_ copiedString:String) -> Void) {
        let pasteboard = NSPasteboard.general
        var changeCount = NSPasteboard.general.changeCount
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let copiedString = pasteboard.string(forType: .string) {
                if pasteboard.changeCount != changeCount {
                    copied(copiedString)
                    changeCount = pasteboard.changeCount
                }
            }
        }
    }
    
    func getForegroundApp() -> NSRunningApplication? {
        let apps = NSWorkspace.shared.runningApplications
        for app in apps {
            if app.isActive {
                return app
            }
        }
        return nil
    }
}

extension MainViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
        case #selector(NSResponder.moveDown(_:)):
            self.moveSelectedItem(next: true)
            return true
        case #selector(NSResponder.moveUp(_:)):
            self.moveSelectedItem(next: false)
            return true
        case #selector(NSResponder.insertNewline(_:)):
            self.copyTo()
            NSApplication.shared.windows.last?.close()
            return true
        case #selector(NSResponder.cancelOperation(_:)):
            NSApplication.shared.windows.last?.close()
            return true
        default:
            return false
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        let textField = obj.object as! NSTextField
        let text = textField.stringValue
        self.searchResult = self.list.filter({$0.contains(text)})
        self.listCollectionViewDelegate.data = self.searchResult
        self.listCollectionView.reloadData()
    }
}
