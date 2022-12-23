//
//  CoreDataService.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/21/22.
//

import Foundation
import CoreData

class CoreDataService: ObservableObject {
    
    private let container: NSPersistentContainer
    private let containerName: String = "ShortcutPlanner"
    private let entityName: String = "ShortcutEntity"
    
    @Published var savedStats: [ShortcutEntity] = []
    static let shared = CoreDataService()
    
    private init() {
        print("Init from CoreDataService")
        self.container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Errors loading core data!: \(error)")
            }
            self.getShortcuts()
        }
    }
    
    func updateShortcut(shortcut: Shortcut, isComplete: Bool) {
        print("Enabled: \(isComplete)")

        //check if stat is already saved
        if let entity = savedStats.first(where: { $0.title == shortcut.title }) {
            update(entity: entity, isComplete: isComplete)
        } else {
            add(shortcut: shortcut)
        }
    }

    func getShortcuts() {
        let request = NSFetchRequest<ShortcutEntity>(entityName: entityName)
        do {
            savedStats = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching health stats: \(error.localizedDescription)")
        }
    }
    
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                container.viewContext.delete(objectData)
                applyChanges()
            }
        } catch let error {
            print("Detele all data in \(entityName) error :", error)
        }
    }

    func add(shortcut: Shortcut) {
        let entity = ShortcutEntity(context: container.viewContext)
        entity.title = shortcut.title
        entity.id = shortcut.id
        entity.isComplete = false
        entity.order = Int16(shortcut.order)
        applyChanges()
    }

    func update(entity: ShortcutEntity, isComplete: Bool) {
        entity.isComplete = isComplete
        applyChanges()
    }

    func delete(entity: ShortcutEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("error saving to core data: \(error)")
        }
    }

    func applyChanges() {
        save()
        getShortcuts()
    }
    
}
