//
//  AppParams.swift
//  ClipboardManager
//
//  Created by Pavel on 17.12.2021.
//  Copyright © 2021 Pavel Morozov. All rights reserved.
//

import Foundation

public struct AppParams {
    public static let mainProductId = "clipboardManager"
    public static let launcherProductId = "launcher"
    public static let organizationId = "com.b333i"
    public static var mainBundleName: String {
        get {
            return organizationId + "." + mainProductId
        }
    }
    public static var launcherBundleName: String {
        get {
            return organizationId + "." + launcherProductId
        }
    }
    public static let killLauncherNotificationName = Notification.Name("killLauncher")
}
