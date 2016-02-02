//
//  Feed.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/28/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation
import CoreData

@objc class Feed: NSManagedObject {
    
    // attributes
    
    /// Name of the feed specified by the user.
    @NSManaged var name: String
    /// The type of feed (e.g. RSS, atom, google)
    @NSManaged var type: String
    /// The search term for the feed
    @NSManaged var query: String?
    /// The destination URL for the feed
    @NSManaged var url: String?
    /// The last time that the feed was refreshed
    @NSManaged var lastUpdated: NSDate
    
    // relationships
    
    /// News articles associated with the feed (individual articles)
    @NSManaged var articles: [Article]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, type: String, query: String?, url: String?, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Feed", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.type = type
        self.query = query
        self.url = url
    }
    
}
