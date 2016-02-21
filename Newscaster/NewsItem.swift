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
    var date: NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        // return formatted date or the starting point of the epoch
        return formatter.dateFromString(dateString) ?? NSDate(timeIntervalSince1970: 0)
    }
    let dateString: String
    let source: String
    
    init(rss: [String : AnyObject]) {
        self.title = rss["title"] as? String ?? ""
        self.description = rss["description"] as? String ?? ""
        self.link = rss["link"] as? String ?? ""
        // TODO: Get the date from the result
        
        let pubDate = rss["pubDate"] as? String ?? ""
        self.dateString = pubDate
        self.source = ""
    }
    
    init(bing: [String: AnyObject]) {
        self.title = bing["title"] as? String ?? ""
        self.description = bing["description"] as? String ?? ""
        self.link = bing["link"] as? String ?? ""
        let pubDate = bing["pubDate"] as? String ?? ""
        self.dateString = pubDate
        self.source = bing["Source"] as? String ?? ""
    }
    
    
    
    
    
}
