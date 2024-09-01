//
//  CoreDataHandler.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//


import Foundation
import CoreData
class CoreDataHandler {
    
    private let persistentContainerName: String = "PeerRankDataModel"
    init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("error: \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveData() {
        guard viewContext.hasChanges else {return}
        do {
            try viewContext.save()
        } catch {
            fatalError("Error Saving data")
        }
    }
    
    
    func deleteData(entityToDelete: NSManagedObject) {
        
        viewContext.delete(entityToDelete)
        saveData()
    }
    
    func fetchData<T: NSManagedObject>(request :NSFetchRequest<T>) -> [T]{
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
}
