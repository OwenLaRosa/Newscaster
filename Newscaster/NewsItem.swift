//
//  NewsItem.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/27/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

struct NewsItem {
    
    let title: String
    let description: String
    let link: String
    let date: NSDate
    
    init(rss: [String : AnyObject]) {
        self.title = rss["title"] as? String ?? ""
        self.description = rss["description"] as? String ?? ""
        self.link = rss["link"] as? String ?? ""
        // TODO: Get the date from the result
        self.date = NSDate()
    }
    
    
    
    
    
    
    
}
