//
//  RSSClient.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/23/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

class RSSClient {
    
    /// Download JSON data at the destination URL.
    private func downloadJSONData(url: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) -> NSURLSessionTask {
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
    
}
