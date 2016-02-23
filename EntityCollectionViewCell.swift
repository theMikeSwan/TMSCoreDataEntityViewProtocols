//
//  EntityCollectionViewCell.swift
//  
//
//  Created by Mike Swan on 2/22/16.
//
//

import UIKit

class EntityCollectionViewCell: UICollectionViewCell {
    var entity: NSManagedObject! {
        didSet {
            if entity != nil {
                self.configureUI()
            }
        }
    }
    
    func configureUI() {
        fatalError("Subclasses must impelemnt configureUI to properly set up the cell when a new entity is set!!")
    }
}
