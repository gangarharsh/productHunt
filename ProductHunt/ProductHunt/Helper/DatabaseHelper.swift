//
//  DatabaseHelper.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 21/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack{//taken from app delegate
    // MARK: - Core Data stack
    static let shared = CoreDataStack()
    var viewContext: NSManagedObjectContext
    
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }

    init() {
        viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
    }

    private var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ProductHunt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


class DatabaseManager {
    
    class var managedContext:NSManagedObjectContext {
        return CoreDataStack.shared.viewContext
    }
    
    class var persistentContainer: CoreDataStack {
        return CoreDataStack.shared
    }

    class func getEntitesForEntityName(_ entityName: String, sortindId sortingKey: String) -> Array<Any> {
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        let sortDescriptior:NSSortDescriptor = NSSortDescriptor(key: sortingKey, ascending: true)
        fetchRequest.sortDescriptors?.append(sortDescriptior)
        
        do {
            object = try managedContext.fetch(fetchRequest)
        } catch let error as NSError  {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return object
    }
    
    
    class func getEntitesForEntityName(_ entityName: String, sortindId sortingKey: String,ascending:Bool) -> Array<Any> {
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        let sortDescriptior:NSSortDescriptor = NSSortDescriptor(key: sortingKey, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptior]
        
        do {
            object = try managedContext.fetch(fetchRequest)
        } catch let error as NSError  {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return object
    }
    
    
    class func deleteAllEntitiesForEntityName(name:String){
        let fetechRequest = NSFetchRequest<NSManagedObject>(entityName:name)
        do{
            let requestObject = try  managedContext.fetch(fetechRequest)
            
            for object:NSManagedObject in requestObject{
                managedContext.delete(object)
            }
        }catch let error as NSError{
            print("Could not delete. \(error), \(error.userInfo)")
            
        }
    }
    
    class func deleteEntitieForEntity(name:String,field_name:String,field_id:Int){
        let fetechRequest = NSFetchRequest<NSManagedObject>(entityName:name)
        fetechRequest.predicate = NSPredicate(format: "\(field_name) = %@", "\(field_id)")
        do{
            let requestObject = try  managedContext.fetch(fetechRequest)
            
            for object:NSManagedObject in requestObject{
                managedContext.delete(object)
            }
        }catch let error as NSError{
            print("Could not delete. \(error), \(error.userInfo)")
            
        }
    }
    
    class func updateEntitieForEntity(updateObject:NSManagedObject,name:String,field_name:String,field_id:Int){
        let fetechRequest = NSFetchRequest<NSManagedObject>(entityName:name)
        fetechRequest.predicate = NSPredicate(format: "\(field_name) == %d", field_id)
        do{
            let requestObject = try  managedContext.fetch(fetechRequest)
            
            if requestObject.count == 1
            {
                var object = updateObject
                do{
                    try managedContext.save()
                }
                catch
                {
                    print("Could not update. \(error), \(error.localizedDescription)")
                }
            }
        }catch let error as NSError{
            print("Could not update . \(error), \(error.userInfo)")
            
        }
    }
    
    class func getEntitesForEntityName(name:String, withPredicate:NSPredicate) -> [Any]{
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = withPredicate
        
        do{
            object = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return object
    }
    
    class func getEntitesForEntityName(fetchRequest:NSFetchRequest<NSManagedObject>) -> [Any]{
        var object: [Any] = []
        
        do{
            object = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return object
    }
    
    class func getEntitesForEntityName(name:String) -> [Any] {
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            object = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not modify. \(error), \(error.userInfo)")
        }
        return object
    }
    
    class func getEntitesForEntityName(name:String,filter:Any) -> [Any]{
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            object = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not modify. \(error), \(error.userInfo)")
        }
        return object
    }
    
    class func saveDbContext(){
        let managedContext = DatabaseManager.managedContext
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
