//
//  CoreContainer.swift
//  fefuactivity
//
//  Created by students on 29.05.2022.
//

import CoreData

class CoreContainer {
    static let instance = CoreContainer()
    
    private init() { }
    
    private static let containerName = "ActivityData"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let cont = NSPersistentContainer(name: Self.containerName)
        cont.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Ünresolved error \(error), \(error.userInfo)")
            }
        })
        return cont
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
