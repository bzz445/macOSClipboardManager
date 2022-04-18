//
//  ClipboardEntity.swift
//  ClipboardManager
//
//  Created by Pavel on 28.12.2021.
//  Copyright © 2021 Pavel Morozov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ClipboardEntity)
public class ClipboardEntity: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID().uuidString
        type = 1
        date = Date()
        isAttached = false
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClipboardEntity> {
        return NSFetchRequest<ClipboardEntity>(entityName: "ClipboardEntity")
    }
    
    @NSManaged public var id: String
    @NSManaged public var type: Int16
    @NSManaged public var date: Date
    @NSManaged public var isAttached: Bool
    @NSManaged public var data: Data?
    @NSManaged public var appIcon: String?
    @NSManaged public var appName: String?
}

