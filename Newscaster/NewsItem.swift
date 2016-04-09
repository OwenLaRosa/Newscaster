//
//  NewsItem.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/27/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

struct NewsItem {
    
    var title: String
    var description: String
    var link: String
    var date: NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        // return formatted date or the starting point of the epoch
        return formatter.dateFromString(dateString) ?? NSDate(timeIntervalSince1970: NSTimeInterval(dateString) ?? 0)
        // the alternate condition is for Faroo search where the time is returned as a number
    }
    var dateString: String
    var source: String
    
    init(rss: [String : AnyObject]) {
        self.title = rss["title"] as? String ?? ""
        let description = rss["description"] as? String ?? ""
        // remove non-text html elements
        self.description = HTMLScraper(html: description).removeAllTags()
        self.link = rss["link"] as? String ?? ""
        // TODO: Get the date from the result
        
        let pubDate = rss["pubDate"] as? String ?? ""
        self.dateString = pubDate
        self.source = ""
    }
    
    init(bing: [String: AnyObject]) {
        self.title = bing["title"] as? String ?? ""
        let description = bing["description"] as? String ?? ""
        self.description = HTMLScraper(html: description).removeAllTags()
        self.link = bing["link"] as? String ?? ""
        let pubDate = bing["pubDate"] as? String ?? ""
        self.dateString = pubDate
        self.source = bing["Source"] as? String ?? ""
    }
    
    init(faroo: [String: AnyObject]) {
        self.title = faroo["title"] as? String ?? ""
        self.description = faroo["kwic"] as? String ?? ""
        self.link = faroo["url"] as? String ?? ""
        self.dateString = ""
        self.source = faroo["domain"] as? String ?? ""
    }
    
    init(atom: [String: AnyObject]) {
        // ensure all variables are guaranteed a value
        self.title = ""
        self.description = ""
        self.link = ""
        self.dateString = ""
        self.source = ""
        // assign the actual values
        if let title = atom["title"] as? [String: String] {
            self.title = title["content"] ?? ""
        }
        if let content = atom["content"] as? [String: String] {
            let description = content["content"] ?? ""
            if content["type"] == "html" {
                self.description = HTMLScraper(html: description).removeAllTags()
            }
        }
        if let link = atom["link"] as? [[String: String]] {
            for i in link {
                if let title = i["title"] {
                    // determine if this is an actual web page
                    // some services like Blogger will also link to comments
                    if title.hasSuffix("html") {
                        self.link = i["href"] ?? ""
                    }
                }
            }
        }
    }
    
}
