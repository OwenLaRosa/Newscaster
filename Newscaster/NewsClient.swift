//
//  NewsClient.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/23/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

class NewsClient {
    
    /// Download data at the destination URL.
    func downloadData(url: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) -> NSURLSessionTask {
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            completionHandler(data: data, response: response, error: error)
        }
        task.resume()
        
        return task
    }
    
    /// Attempt to convert JSON data into NSDictionary.
    private func parseJSONData(data: NSData, completionHandler: (result: NSDictionary?, error: NSError?) -> Void) {
        do {
            if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary {
                completionHandler(result: parsedResult, error: nil)
            }
        } catch let parsingError as NSError {
            completionHandler(result: nil, error: parsingError)
        }
    }
    
    func getFeedForTerm(query: String, completionHandler: (result: [NewsItem]?, error: String?) -> Void) -> NSURLSessionTask {
        let location = "http://www.faroo.com/api?q=cnn&start=1&length=10&l=en&src=news&i=false&f=json&key="
        let task = downloadData(location) {data, response, error in
            if data == nil {
                completionHandler(result: nil, error: error?.localizedDescription)
            }
            self.parseJSONData(data!) {result, error in
                if result != nil {
                    print(result)
                    let results = result!["results"] as! [[String : AnyObject]]
                    let newsItems = results.map({
                        NewsItem(faroo: $0)
                    })
                    completionHandler(result: newsItems, error: nil)
                }
            }
        }
        return task
    }
    
    func getFeedForRSS(var location: String, completionHandler: (result: [NewsItem]?, error: String?) -> Void) -> NSURLSessionTask {
        location = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20rss%20where%20url%3D%22\(formatURLForSearch(location))%22&format=json&diagnostics=true&callback="
        let task = downloadData(location) {data, response, error in
            if data == nil {
                completionHandler(result: nil, error: error?.localizedDescription)
            }
            self.parseJSONData(data!) {result, error in
                if result != nil {
                    print(result)
                    // retrieve the array of results
                    let query = result!["query"] as! [String: AnyObject]
                    let results = query["results"] as! [String : AnyObject]
                    let item = results["item"] as! [[String : AnyObject]]
                    let newsItems = item.map({
                        NewsItem(rss: $0)
                    })
                    completionHandler(result: newsItems, error: nil)
                }
            }
        }
        return task
    }
    
    func getFeedForAtom(location: String, completionHandler: (result: [String: String]?, error: String?) -> Void) -> NSURLSessionTask {
        let task = downloadData(location) {data, response, error in
            if data == nil {
                completionHandler(result: nil, error: error?.localizedDescription)
            }
            self.parseJSONData(data!) {result, error in
                if result != nil {
                    print(result)
                }
            }
        }
        return task
    }
    
    /// Format the given URL to be used in YQL request.
    private func formatURLForSearch(url: String) -> String {
        let removedColons = url.stringByReplacingOccurrencesOfString(":", withString: "%3A")
        let removedSlashes = removedColons.stringByReplacingOccurrencesOfString("/", withString: "%2F")
        return removedSlashes
    }
    
    /// Format the given query into a valid search string
    private func formatQueryForSearch(var query: String) -> String {
        // for ease of use, make the string lowercase
        query = query.lowercaseString
        // characters allowed for the search query
        let allowedCharacters = "qwertyuiopasdfghjklzxcvbnm1234567890+"
        // replace spaces with "+" to separate the different keywords
        let removedSpaces = query.stringByReplacingOccurrencesOfString("  ", withString: "+")
        // create a new string with only the valid characters
        var result = ""
        for i in removedSpaces.characters {
            if allowedCharacters.containsString(String(i)) {
                result += String(i)
            }
        }
        return result
    }
    
}
