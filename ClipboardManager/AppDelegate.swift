//
//  AppDelegate.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 16.06.2020.
//  Copyright © 2020 Pavel Morozov. All rights reserved.
//

import Cocoa
import Launcher
import ServiceManagement

enum DefaultsKeys: String {
    case startOnLogin = "StartOnLogin"
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var mainWindow: NSWindow
    private var menu = NSMenu()
    private var startOnLoadMenuItem: NSMenuItem?
    private let statusBarItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    override init() {
        let mainStoryBoard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        guard let windowController = mainStoryBoard.instantiateController(withIdentifier: "MainWidowsController") as? NSWindowController,
              let window = windowController.window else {
            fatalError("Can`t load Main.storyboard")
        }
        mainWindow = window
        super.init()
    }
    
    //MARK: LifeCycle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == AppParams.launcherBundleName }.isEmpty
        if isRunning {
            DistributedNotificationCenter.default().post(name: AppParams.killLauncherNotificationName, object: AppParams.mainBundleName)
        }
        
        createMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Private
    
    private func createMenu() {
        // icon
        if let button = statusBarItem.button {
            button.image = NSImage(named:NSImage.Name("tray"))
            button.action = #selector(handleButtonAction(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseDown])
        }

        // menu
        startOnLoadMenuItem = NSMenuItem(title: "Start On Login", action: #selector(menuClickStartOnLoad), keyEquivalent: "")
        startOnLoadMenuItem?.state = UserDefaults.standard.bool(forKey: DefaultsKeys.startOnLogin.rawValue) ? .on : .off
        
        menu.delegate = self
        menu.addItem(withTitle: "Clear history", action: #selector(menuClickClear), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(startOnLoadMenuItem!)
        menu.addItem(withTitle: "About", action: #selector(menuClickAbout), keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(didTapQuit), keyEquivalent: "")
    }
    
    private func showWindow() {
        // переподписываемся на событие, потому что есть подозрение,
        // что после сна происходит отписка и уведомления больше не ходят
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(didResignKeyNotification), name: NSWindow.didResignKeyNotification, object: nil)
        
        if NSScreen.screens.count > 1 {
            let screen = NSScreen.getActive()
            let windowSize = mainWindow.frame.size
            // вычисляем frame для центра (по вертикали и чуть выше центра по горизонтали) окна на выбранном мониторе
            let windowFrame = CGRect(
                x: screen.frame.origin.x + screen.frame.size.width / 2 - windowSize.width / 2,
                y: screen.frame.origin.y + screen.frame.size.height / 2 + windowSize.height / 2,
                width: windowSize.width,
                height: windowSize.height)
            
            mainWindow.setFrame(windowFrame, display: true)
        }
        mainWindow.makeKeyAndOrderFront(nil)
        mainWindow.orderFrontRegardless()
        //NSApplication.shared.activate(ignoringOtherApps: true)
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
            mainWindow.close()
            statusBarItem.menu = menu // добавляем меню
            statusBarItem.button?.performClick(nil) // ...и нажимаем программно
        } else {
            // на левую кнопку показываем или скрываем окно
            if mainWindow.isVisible {
                mainWindow.close()
            } else {
                showWindow()
            }
        }
    }
    
    @objc func didResignKeyNotification() {
        mainWindow.close()
    }
    
    // menu handle items
    @objc func menuClickClear() {
//        mainViewController.clear()
    }
    
    @objc func menuClickStartOnLoad() {
        let startOnLogin = UserDefaults.standard.bool(forKey: DefaultsKeys.startOnLogin.rawValue)
        UserDefaults.standard.setValue(!startOnLogin, forKey: DefaultsKeys.startOnLogin.rawValue)
        startOnLoadMenuItem?.state = startOnLogin ? .on : .off
        SMLoginItemSetEnabled(AppParams.launcherBundleName as CFString, !startOnLogin)
    }
    
    @objc func menuClickAbout() {
        guard let window = AboutWindowController.defaultController.window else {
            return
        }

        window.orderFrontRegardless()
        NSApplication.shared.activate(ignoringOtherApps: true)
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
