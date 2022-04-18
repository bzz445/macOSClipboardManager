//
//  ClipboardModel.swift
//  ClipboardManager
//
//  Created by Pavel on 28.12.2021.
//  Copyright © 2021 Pavel Morozov. All rights reserved.
//

import Foundation

enum ClipboardType: Int {
    case string = 1
}

struct ClipboardModel {
    struct AppModel {
        var icon: String?
        var name: String?
    }

    var type: ClipboardType
    var date: String
    var isAttached: Bool
    var rawData: Data?
    var app: AppModel?
}
