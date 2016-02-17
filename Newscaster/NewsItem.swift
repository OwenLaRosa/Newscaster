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
    let source: String?
    
    init(rss: [String : AnyObject]) {
        self.title = rss["title"] as? String ?? ""
        self.description = rss["description"] as? String ?? ""
        self.link = rss["link"] as? String ?? ""
        // TODO: Get the date from the result
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        // return formatted date or the starting point of the epoch
        self.date = formatter.dateFromString(rss["pubDate"] as? String ?? "") ?? NSDate(timeIntervalSince1970: 0)
        self.source = nil
    }
    
    init(bing: [String: AnyObject]) {
        self.title = bing["title"] as? String ?? ""
        self.description = bing["description"] as? String ?? ""
        self.link = bing["link"] as? String ?? ""
        self.date = NSDate()
        self.source = bing["Source"] as? String ?? ""
    }
    
    
    
    
    
}
