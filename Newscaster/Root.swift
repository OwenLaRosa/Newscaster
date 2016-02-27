//
//  Root.swift
//  Newscaster
//
//  Created by Owen LaRosa on 2/27/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation
import CoreData

@objc class Root: NSManagedObject {
    
    /// Ordered set of all Feed entities
    @NSManaged var feeds: NSMutableOrderedSet
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Root", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
}
