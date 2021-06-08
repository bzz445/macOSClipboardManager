//
//  AppDelegate.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 16.06.2020.
//  Copyright © 2020 Pavel Morozov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarMenu = NSMenu()
    private let statusBarItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    private var windowController: NSWindowController!
    private var mainViewController: ViewController!
    
    //MARK: LifeCycle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // icon
        if let button = statusBarItem.button {
            button.image = NSImage(named:NSImage.Name("tray"))
            button.action = #selector(handleButtonAction(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseDown])
        }

        // menu
        statusBarMenu.delegate = self
        statusBarMenu.addItem(withTitle: "Clear history", action: #selector(didTapClear), keyEquivalent: "")
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "Quit", action: #selector(didTapQuit), keyEquivalent: "")
        
        // window
        let mainStoryBoard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        windowController = mainStoryBoard.instantiateController(withIdentifier: "MainWidowsController") as? NSWindowController
        mainViewController = windowController.window!.contentViewController as? ViewController
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Private
    
    private func showWindow() {
        guard let window = self.windowController.window else {
            print("[AppDelegate] cant find window")
            return
        }
        
        // переподписываемся на событие, потому что есть подозрение,
        // что после сна происходит отписка и уведомления больше не ходят
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(didResignKeyNotification), name: NSWindow.didResignKeyNotification, object: nil)
        
        if NSScreen.screens.count > 1 {
            let screen = NSScreen.screens[getActiveScreenIndex()]
            // вычисляем frame для центра (по вертикали и чуть выше центра по горизонтали) окна на выбранном мониторе
            let windowFrame = CGRect(
                x: screen.frame.origin.x + screen.frame.size.width / 2 - window.frame.size.width / 2,
                y: screen.frame.origin.y + screen.frame.size.height / 2 + window.frame.size.height / 2,
                width: window.frame.size.width,
                height: window.frame.size.height)
            
            window.setFrame(windowFrame, display: true)
        }
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        //NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    /// Определяем на каком мониторе курсор
    /// - Returns: индекс монитора
    private func getActiveScreenIndex() -> Int {
        var result = 0
        for (index, screen) in NSScreen.screens.enumerated() {
            if screen.frame.contains(NSEvent.mouseLocation) {
                result = index
                break
            }
        }
        return result
    }
    
    //MARK: Selectors
    
    /// Нажатие на левой или правой кнопкой на иконку в статус баре
    /// - Parameter sender: sender
    @objc func handleButtonAction(_ sender: Any?) {
        guard let event = NSApp.currentEvent else {
            showWindow()
            return
        }

        // правая кнопка
        if event.type == .rightMouseDown || event.type == .rightMouseUp {
            windowController.window!.close()
            statusBarItem.menu = statusBarMenu // добавляем меню
            statusBarItem.button?.performClick(nil) // ...и нажимаем программно
        } else {
            // на левую кнопку показываем или скрываем окно
            if windowController.window?.isVisible ?? false {
                windowController.window!.close()
            } else {
                showWindow()
            }
        }
    }
    
    @objc func didResignKeyNotification() {
        self.windowController.window!.close()
    }
    
    // menu handle items
    
    @objc func didTapClear() {
        mainViewController.clear()
    }
    
    @objc func didTapQuit() {
        NSApplication.shared.terminate(self)
    }
}

extension AppDelegate: NSMenuDelegate {
    @objc func menuDidClose(_ menu: NSMenu) {
        // удаляем меню после его открытия, потому что если этого не сделать
        // то оно само откроется при следующем любом клике, а нам нужно его открывать только по ПКМ
        statusBarItem.menu = nil
    }
}
