//
//  CDEntityViewProtocol.swift
//  
//  Created by Mike Swan on 1/19/16.

import UIKit
import CoreData

/*
CDEntityTableViewProtocol builds on CDEntityViewProtocol adding the code needed for table views.
The implementer of this protocol can either be the view controller in charge of the table view or a separate object that supplies the table view with its data.

Usage:
Provide a connection to the table view that is to be supplied with data and then implement configureCell(cell:, atIndex:) to setup the cell as needed for the perticular entity being displayed.
*/
protocol EntityTableViewDataSourceProtocol: CDEntityViewProtocol, UITableViewDataSource {
    var tableView: UITableView? {get set}
}

extension EntityTableViewDataSourceProtocol {
    func reloadDataView() {
        tableView?.reloadData()
    }
    
    // MARK: - TableView DataSource and Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard fetchedResultsController != nil else { return 0 }
        let sectionInfo = self.fetchedResultsController!.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIDForIndexPath(indexPath: indexPath), forIndexPath: indexPath)
        self.configureCell(cell, atIndex: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndex indexPath: NSIndexPath) {
        let theCell = cell as! EntityTableViewCell
        theCell.entity = self.fetchedResultsController.objectAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard managedObjectContext != nil else { return }
        if editingStyle == .Delete {
            managedObjectContext!.deleteObject(fetchedResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject)
            managedObjectContext!.processPendingChanges()
        } else if editingStyle == .Insert {
            self.addItem(NSNull)
        }
    }
    
    // MARK: - FetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard tableView != nil else { return }
        switch type {
        case .Insert:
            tableView!.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView!.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView!.cellForRowAtIndexPath(indexPath!)!, atIndex: indexPath!)
        case .Move:
            tableView!.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView!.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.endUpdates()
    }
}
