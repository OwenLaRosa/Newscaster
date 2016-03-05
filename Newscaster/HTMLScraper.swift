//
//  HTMLScraper.swift
//  Newscaster
//
//  Created by Owen LaRosa on 2/25/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

class HTMLScraper {
    
    let html: String
    
    init(html: String) {
        self.html = html
    }
    
    /// Returns a string with all contents inbetween angle brackets removed
    func removeAllTags() -> String {
        var result = ""
        var inTag = false
        for i in html.characters {
            if inTag {
                if i == ">" {
                    inTag = false
                }
                continue
            }
            if i == "<" {
                inTag = true
                continue
            }
            result.append(i)
        }
        return result
    }
    
    /// Extract the URL from a link provided by a news result
    func getURLFromNewsLink(link: String) -> String {
        // starting and ending indicators
        let startString = "&url="
        let endString = "&c="
        // find first index of url
        let startIndex = link.rangeOfString(startString)?.endIndex ?? link.startIndex
        // find last index of url
        let endIndex = link.rangeOfString(endString)?.startIndex ?? link.endIndex
        // find string between the two indices
        let subString = link.substringToIndex(endIndex).substringFromIndex(startIndex)
        // remove escape codes and return the result
        return replaceEscapeCodesFromString(subString)
    }
    
    /// Replaces escape codes in the specified string with their correct characters
    func replaceEscapeCodesFromString(var string: String) -> String {
        // will use just a few for now
        let escapeCodeDictionary = [
            "%3a": ":",
            "%2f": "/",
            "%3d": "="
        ]
        for i in escapeCodeDictionary.keys {
            string = string.stringByReplacingOccurrencesOfString(i, withString: escapeCodeDictionary[i]!)
        }
        return string
    }
    
    /// Return an array containing the contents for each instance of the specified tag
    func getContentsForTag(tag: String) -> [String] {
        let startTag = "<\(tag)"
        let endTag = "</\(tag)>"
        var html = self.html
        var tagContents = [String]()
        
        while let startRange = html.rangeOfString(startTag) {
            if let endRange = html.rangeOfString(endTag) {
                let range = Range(start: startRange.startIndex, end: endRange.startIndex)
                let contents = html.substringWithRange(range)
                tagContents.append(contents)
                html = html.substringFromIndex(endRange.endIndex)
            }
        }
        return tagContents
    }
    
}
