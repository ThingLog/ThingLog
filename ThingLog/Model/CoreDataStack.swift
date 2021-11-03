//
//  CoreDataProvider.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/14.
//

import CoreData
import Foundation

final class CoreDataStack {
    static let shared: CoreDataStack = CoreDataStack()

    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = NSPersistentContainer(name: "ThingLog")

        container.loadPersistentStores { description, error in
            if let error: NSError = error as NSError? {
                print(description.url)
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    var mainContext: NSManagedObjectContext { persistentContainer.viewContext }
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()

    func saveContext() {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("CoreDataStack Unresolved error \(error)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
