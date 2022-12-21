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
//    static let shared = HealthStatDataService()
    
    private init() {
        print("Init from CoreDataService")
        self.container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Errors loading core data!: \(error)")
            }
            self.getHealthStats()
        }
    }
    
//    func updateStats(healthStat: HealthStat, isEnabled: Bool, goalAmount: Double? = nil) {
//        print("Enabled: \(isEnabled)")
//
//        //check if stat is already saved
//        if let entity = savedStats.first(where: { $0.title == healthStat.title }) {
//            update(entity: entity, isEnabled: isEnabled, goalAmount: goalAmount)
//        } else {
//            add(healthStat: healthStat, isEnabled: isEnabled)
//        }
//    }
//
    func getHealthStats() {
        let request = NSFetchRequest<ShortcutEntity>(entityName: entityName)
        do {
            savedStats = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching health stats: \(error.localizedDescription)")
        }
    }

    func add(shortcut: Shortcut) {
        let entity = ShortcutEntity(context: container.viewContext)
        entity.title = shortcut.title
        entity.id = shortcut.id
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
        getHealthStats()
    }
    
}
