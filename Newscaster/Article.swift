//
//  Article.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/28/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation
import CoreData

@objc class Article: NSManagedObject {
    
    /// The title of the article
    @NSManaged var title: String
    /// The URL where the article is located
    @NSManaged var link: String
    /// The author or site who published the article
    @NSManaged var source: String?
    /// Preview text of the article
    @NSManaged var preview: String?
    /// The article's publication date
    @NSManaged var date: NSDate?
    /// String representation of the publication date
    @NSManaged var dateString: String
    /// Plaintext content of the article
    @NSManaged var textContent: String?
    
    /// Feed entity associated with the article.
    @NSManaged var feed: Feed
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(newsItem: NewsItem, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Article", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.title = newsItem.title
        self.link = newsItem.link
        //self.source = newsItem.source
        self.preview = newsItem.description
        self.date = newsItem.date
    }
    
}
