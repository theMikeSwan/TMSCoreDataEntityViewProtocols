//
//  CDEntityViewProtocol.swift
//
//  Created by Mike Swan on 1/19/16.

import UIKit
import CoreData

/**
CDEntityViewProtocol is the root protocol for simplifying the display of Core Data entities in data views (such as table views and collection views).
This protocol and its extension handle the common feteched results tasks while the sub-protocols, CDEntityTableViewProtocol and CDEntityCollectionViewProtocol, handle the specifics for table views and collection views.

Usage:
In order to use this protocol the class that implements it needs to provide an implementation of sortDescriptors() and entityName(). For more details see the documentation for each of those functions.
*/
protocol EntityDataSourceProtocol: NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext? {get set}
    var fetchedResultsController: NSFetchedResultsController? {get set}
    
    /// Returns the reuse identifier that should be used for the table or collections view cells. The default is "managedObjectCell". The index path of the cell is passed in to allow different resuse IDs to be used if needed.
    func cellReuseIDForIndexPath(indexPath: NSIndexPath) -> String
    /// The desired size for fetch batches, the default is 20.
    func fetchReguestBatchSize() -> Int
    /// Starts the fetch request running, called when a non nil managed object context is set
    func initiateFetchRequest()
    /// Called if the fetch request is successful so that the data view can be refreshed with the new data.
    func reloadDataView()
    /// Adds a new Core Data entity of the type specified in entityName()
    func addItem()
    /// Returns an array of sort decriptors to be used on the fetch results.
    func sortDescriptors() -> [NSSortDescriptor]
    /// Returns the name of the entity to be fetched.
    func entityName() -> String
}

extension EntityDataSourceProtocol {
    var managedObjectContext: NSManagedObjectContext? {
        get {
            return self.managedObjectContext
        }
        set {
            self.managedObjectContext = newValue
            if managedObjectContext != nil {
                self.initiateFetchRequest()
            }
        }
    }
    func cellReuseIDForIndexPath(indexPath: NSIndexPath) -> String {
        return "managedObjectCell"
    }
    func fetchBatchSize() -> Int {
        return 20
    }
    
    func initiateFetchRequest() {
        if managedObjectContext != nil {
            let request = NSFetchRequest()
            let entity = NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: self.managedObjectContext!)
            request.entity = entity
            request.fetchBatchSize = self.fetchBatchSize()
            request.sortDescriptors = self.sortDescriptors()
            let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController = controller
            fetchedResultsController!.delegate = self
            do {
                try fetchedResultsController!.performFetch()
                self.reloadDataView()
            } catch {
                NSLog("Error fetching \(self.entityName()) entities: \(error)")
            }
        }
    }
    
    func addItem(sender: AnyObject) {
        if managedObjectContext != nil {
            _ = NSEntityDescription.insertNewObjectForEntityForName(self.entityName(), inManagedObjectContext:managedObjectContext!)
            managedObjectContext!.processPendingChanges()
        }
    }
}