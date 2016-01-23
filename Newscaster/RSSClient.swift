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
    
    func getFeedForTerm(query: String, completionHandler: (result: [String: String]?, error: String?) -> Void) -> NSURLSessionTask {
        let location = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20rss%20where%20url%3D%22https%3A%2F%2Fwww.bing.com%2Fnews%2Fsearch%3Fq%3D\(query)%26go%3DSubmit%26qs%3Dn%26form%3DQBNT%26pq%3D\(query)%26sc%3D8-7%26sp%3D-1%26sk%3D%26ghc%3D1%26format%3Drss%22&format=json&diagnostics=true&callback="
        let task = downloadJSONData(location) {data, response, error in
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
    
    func getFeedForRSS(location: String, completionHandler: (result: [String: String]?, error: String?) -> Void) -> NSURLSessionTask {
        let task = downloadJSONData(location) {data, response, error in
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
    
    func getFeedForAtom(location: String, completionHandler: (result: [String: String]?, error: String?) -> Void) -> NSURLSessionTask {
        let task = downloadJSONData(location) {data, response, error in
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
    
}
