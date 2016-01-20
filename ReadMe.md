#TMSCoreDataEntityViewProtocols


##About:
TMSCoreDataEntityViewProtocols makes use of the power and flexibility of protocols in Swift to ease the work of displaying Core Data entities in table views and collection views. In addition the base protocol, `CDEntityViewProtocol`, can be extended to supply entities in other situations where a fetched results controller is used. The power of these protocol comes from the fact that you can provide default implementations of function in protocol extensions, as such each protocol has an extension that implements most of the functions listed in the protocol. There are still a few you will need to implement yourself as seen below.

TMSCoreDataEntityViewProtocols is comprised of three protocols, they are:  

* `CDEntityViewProtocol`, it is the base protocol that creates the fetch request and begins execution of it.  
* `CDEntityTableViewProtocol`, it conforms to `CDEntityViewProtocol` and `UITableViewDataSource`. It adds the necessary code to supply a table view with the entities retrieved by the fetched results controller.  
* `CDEntityCollectionViewProtocol`, it conforms to `CDEntityViewProtocol` as well along with `UICollectionViewDataSource`. It adds the necessary code to supply the entities from the fetched results controller to a collection view.

##Usage:
###All Views:
The class that conforms to one of these protocols can either be the view controller that has the table view, collection view, etc. in it or it can be a helper class (this method has the benefit of keeping the view controller smaller though the additional code required is very minimal). From now on we will call the class that conforms to one of these protocols as the conforming class.  
In order to affect updates of a table or collection view the conforming class will need a connection to the view in question (the table and collection protocols have appropriately named properties for this connection). In addition the conforming class will need to at least be the data source of the view in question.  
In order for the proper entities to be fetched the conforming class needs to implement the function `entityName()` and return the name of the desired entity. This function is called both when determining what type of entities to fetch and when determining what kind to add when `addItem()` is called.  
The conforming class also needs to implement `sortDescriptors()` and return an array of sort descriptors for sorting the results.  
By default the fetched results controller will be set to have a batch size of 20, if you want to change this number simply implement `fetchRequestBatchSize()` and return the desired number.  
The default reuse identifier for table and collection view cells is "managedObjectCell" if you want to use a different ID simply implement `cellReuseIdentifier()` and return a string with the desired ID.

###Table Views:
For table views all that you need to implement in addition to the above functions is `configureCell(_:, atIndex:)` to setup the cell as appropriate for the entity to be displayed. If you have a `UITableViewCell` that configures itself when passed an entity you can simply cast the cell you are passed to the right class and assign the correct entity from the fetched results to the cell.  
Everything else is taken care of for you unless you want to override the default behavior in any of the existing functions, they are generic enough to not need modification in most cases.

###Collection Views:
The only function that needs implementing in addition to those mentioned in e first section is `configureCell(_:, atIndex:)` unlike table view cells you will likely need to cast the passed in `UICollectionViewCell` to the correct kind of cell for your app.


##Moving Forward:
Currently when a collection view gets updates from the fetched results controller each update gets sent individually as `UICollectionView` doesn't have the same `beginUpdates()` and `endUpdates()` as `UITableView` and when using `UICollectionView`'s `performBatchUpdates(_:, completion:)` the deletes are done first necessitating modification of index paths for all other changes. I hope to add the necessary code in the future to build up an array of changes with the correct indexes so they can all be done in one batch.  
I also want to add default table and collection view cells that take an entity as a property and configure themselves as needed. I'm still working out the best way to do this as not all of the attributes within the entity will be wanted in the cell and the order and other display details of the attributes that are desired will vary greatly between apps.

##Contributing:
I would be happy to review any pull requests or suggestions you might have so please don't be shy!