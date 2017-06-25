//
//  CoreDataStack.swift
//  PhunwareAssignment
//
//  Created by Ashish Mishra on 6/24/17.
//  Copyright © 2017 Ashish Mishra. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {

    
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "PhunwareAssignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveInCoreDataWithEvents(events : [EventInfo]) {
        for aEvent in events {
            self.createUserEventOfflineFrom(event: aEvent)
        }
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    
    func  createUserEventOfflineFrom(event : EventInfo)  {
        
                if self.checkIfAlreadyExists(eventId: event.eventId!) {
                    return
                }
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let eventEntity = NSEntityDescription.insertNewObject(forEntityName: "EventOfflineInfo", into: context) as? EventOfflineInfo {
            
            eventEntity.eventId = Int64(event.eventId!)
            eventEntity.title = event.title
            eventEntity.eventDescription = event.eventDescription
            eventEntity.eventDate = event.eventDate
            eventEntity.city = event.city
            eventEntity.place = event.place
            
            
        }
    }
    
    func saveImageToCoreData(data : Data?, eventInfo : EventInfo) {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventOfflineInfo", in: context)
        
        fetchRequest.entity = entityDescription
        
        fetchRequest.propertiesToFetch = ["eventId"]
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try context.fetch(fetchRequest)
            
            for aObj in result {
                
                let eventManagedObj = aObj as! EventOfflineInfo
                
                if Int(eventManagedObj.eventId) == eventInfo.eventId {
                    
                    eventManagedObj.setValue(data, forKey: "bgImage")
                    
                    do {
                        try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
                    } catch let error {
                        print(error)
                    }
                    
                    return
                }
                
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    func checkIfAlreadyExists(eventId : Int) -> Bool{
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventOfflineInfo", in: context)
        
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "eventId = %d",eventId)
        
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count > 0 {
                return true
            }
            
        } catch {
            let fetchError = error as NSError
            return false
        }
        return false
    }
    
    func fetchResultsFromCoreData(completionHandler : @escaping ([Any]?, Error?) -> ()) {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventOfflineInfo", in: context)
        
        fetchRequest.entity = entityDescription
        
        do {
            let result = try context.fetch(fetchRequest)
            var events : [EventInfo] = []
            for aObj in result {
                let managedObject = aObj as! EventOfflineInfo
                let eventInfo = EventInfo()
                eventInfo.title = managedObject.title != nil ? managedObject.title : nil
                eventInfo.eventDescription = managedObject.eventDescription != nil ? managedObject.eventDescription : nil
                eventInfo.eventDate = managedObject.eventDate != nil ? managedObject.eventDate : nil
                eventInfo.city = managedObject.city != nil ? managedObject.city : nil
                eventInfo.place = managedObject.place != nil ? managedObject.place : nil
                eventInfo.bgImage = managedObject.bgImage != nil ? UIImage(data : managedObject.bgImage! as Data) : nil
                
                events.append(eventInfo)
            }
            
            completionHandler(events,nil)
        } catch {
            let fetchError = error as NSError
            completionHandler(nil,fetchError)
        }
    }
    
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
    
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
