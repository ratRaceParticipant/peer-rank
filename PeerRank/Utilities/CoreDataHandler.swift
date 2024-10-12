//
//  CoreDataHandler.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//


import Foundation
import CoreData
class CoreDataHandler {
    
    private let persistentContainerName: String = Constants.dataSourceName
    init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
//        let url = URL.getDatabaseStoreUrl(for: Constants.appGroup, databaseName: persistentContainerName)
//        let storeDescription = NSPersistentStoreDescription(url: url)
//        container.persistentStoreDescriptions = [storeDescription]
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
            return
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

extension URL {
    static func getDatabaseStoreUrl(for appGroup: String, databaseName: String) -> URL{
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else{
            fatalError("Unable to create URL for Database")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
