//
//  String.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 20.05.2021.
//  Copyright © 2021 Pavel Morozov. All rights reserved.
//

import Foundation

extension String {
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s]+", with: " ", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
