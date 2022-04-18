//
//  PersistentManager.swift
//  ClipboardManager
//
//  Created by Pavel on 28.12.2021.
//  Copyright © 2021 Pavel Morozov. All rights reserved.
//

import Foundation
import CoreData

protocol PersistentManagerProtocol {
    func insert(_ model: ClipboardModel)
}

class PersistentManager {
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext
    
    init() {
        context = persistentContainer.viewContext
    }
    
    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }
    
    private func map(fromModel model: ClipboardModel) -> ClipboardEntity {
        let entity = ClipboardEntity(context: context)
        entity.type = Int16(model.type.rawValue)
        entity.isAttached = model.isAttached
        entity.data = model.rawData
        entity.appName = model.app?.name
        entity.appIcon = model.app?.icon
        return entity
    }
    
    private func map(fromEntity entity: ClipboardEntity) -> ClipboardModel {
        return ClipboardModel(type: .string, date: "", isAttached: false) // TODO
    }
}

extension PersistentManager: PersistentManagerProtocol {
    public func insert(_ model: ClipboardModel) {
        _ = map(fromModel: model)
        saveContext()
    }
    
    public func getAll() -> [ClipboardModel] {
        var result: [ClipboardModel] = []
        let fetchRequest: NSFetchRequest<ClipboardEntity> = ClipboardEntity.fetchRequest()
        guard let objects = try? context.fetch(fetchRequest) else {
            return result
        }
        
        for object in objects {
            result.append(map(fromEntity: object))
        }
        
        return result
    }
}
