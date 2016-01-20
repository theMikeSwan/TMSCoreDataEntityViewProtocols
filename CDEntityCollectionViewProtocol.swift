//
//  CDEntityViewProtocol.swift
//  
//
//  Created by Mike Swan on 1/19/16.
//
//

import UIKit
import CoreData


/*
CDEntityCollectionViewProtocol builds on CDEntityViewProtocol adding the code needed for collection views.
The implementer of this protocol can either be the view controller in charge of the collection view or a separate object that supplies the collection view with its data.

Usage:
Provide a connection to the collection view that is to be supplied with data and then implement configureCell(cell:, atIndex:) to setup the cell as needed for the perticular entity being displayed.
*/
protocol CDEntityCollectionViewProtocol: CDEntityViewProtocol, UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView: UICollectionView? {get set}
    func configureCell(cell: UICollectionViewCell, atIndex indexPath: NSIndexPath)
}

extension CDEntityCollectionViewProtocol {
    func reloadDataView() {
        collectionView?.reloadData()
    }
    
    // TODO: fix the FetchedResultsControllerDelegate functions below and add collection view functions.
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard fetchedResultsController != nil else { return 0 }
        let sectionInfo = self.fetchedResultsController!.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseID(), forIndexPath: indexPath)
        configureCell(cell, atIndex:indexPath)
        return cell
    }
    
    // MARK: - FetchedResultsControllerDelegate
    // TODO: refactor this so that all the updates go into a batch with performBatchUpdates(_:, completion:). The issue will be with deletes being processed first in batches so other index paths will need to be modified.
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard collectionView != nil else { return }
        switch type {
        case .Insert:
            collectionView!.insertItemsAtIndexPaths([newIndexPath!])
        case .Delete:
            collectionView!.deleteItemsAtIndexPaths([indexPath!])
        case .Update:
            collectionView!.reloadItemsAtIndexPaths([indexPath!])
        case .Move:
            collectionView!.moveItemAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
}
