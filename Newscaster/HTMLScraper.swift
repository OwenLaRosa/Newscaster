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
    /// Contents of tags that are never part of an article's main content
    private let forbidden = ["Caption", "Close", "Advertisement"]
    
    init(html: String) {
        self.html = html
    }
    
    /// Returns a string with all contents inbetween angle brackets removed from the html string
    func removeAllTags() -> String {
        return removeTagsFromString(html)
    }
    
    /// Returns a string with all contents inbetween angle brackets removed
    func removeTagsFromString(string: String) -> String {
        var result = ""
        var inTag = false
        for i in string.characters {
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
    
    /// Removes ampersand codes of the format "&#0000;" from the string
    func removeUnknownAmpersandCodes(fromString string: String) -> String {
        var result = ""
        var isAmpersandCode = false
        for i in string.startIndex..<string.endIndex {
            if string[i] == Character("&") {
                // inside of ampersand code, disallow appending to the string
                isAmpersandCode = string[i.successor()] == "#"
                continue
            }
            if isAmpersandCode {
                if string[i] == Character(";") {
                    // outside of ampersand code, re-allow appending to the string
                    isAmpersandCode = false
                }
                continue
            }
            result += String(string[i])
        }
        return result
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
        // remove contents that are simply a hyperlink (in most cases, links to related articles)
        tagContents = tagContents.filter() {
            return !$0.hasPrefix("<a href") && !$0.hasSuffix("</a>")
        }
        return filterArticleTextFromContents(tagContents.map({removeTagsFromString($0)}))
    }
    
    /// Return only the contents of the array that pertain to article text.
    func filterArticleTextFromContents(var contents: [String]) -> [String] {
        // Note: the procedure used is certainly not ideal as it relies on guessing and assumptions but is good enough for an initial release.
        // And hoping that the assumptions are accurate, it should work in the majority of cases.
        var result = [String]()
        
        // remove characters that shouldn't be pronounced
        contents = contents.map() {
            var newString = $0
            // replace all allowed ampersand codes in each string with their text equivalents
            for i in allowedAmpersandCodes.keys {
                newString = newString.stringByReplacingOccurrencesOfString(i, withString: self.allowedAmpersandCodes[i]!)
            }
            // remove escape characters from the string
            for i in escapeCharacters {
                newString = newString.stringByReplacingOccurrencesOfString(i, withString: " ")
            }
            return removeUnknownAmpersandCodes(fromString: newString)
        }
        
        for i in contents {
            if forbidden.contains(i) {
                continue
            }
            // remove copyright lines where &copy; has already been replaced
            if i.hasPrefix("Copyright Copyright") {
                continue
            }
            // remove unreasonable whitespace
            if i.containsString("        ") || i.containsString("\t\t") { // double tab characters
                continue
            }
            // remove non-sentence like content (no periods)
            // generally includes tags, links or other unneeded information
            if !i.containsString(".") && !i.containsString(":") { // check for colons in section headers
                continue
            }
            if i.lowercaseString.hasPrefix("click for more") || i.lowercaseString.hasPrefix("click here for more") || i.lowercaseString.hasPrefix("click here to") {
                // common title for external link, not part of the article
                continue
            }
            // don't read code for embedding image captions
            if i.hasPrefix("[caption") {
                continue
            }
            result.append(i)
        }
        
        return result
    }
    
    /// Ampersand codes used by HTML and their conversions into plain text form. Some codes are not included because they do not have a text equivalent.
    private let allowedAmpersandCodes = [
        // quotes
        "&quot;" : "\"",
        "&#39;": "'",
        // ampersand
        "&amp;" : "&",
        // comparison operators
        "&lt;" : "<",
        "&gt;" : ">",
        // currencies
        "&cent;" : "cent",
        "&pound;" : "pound",
        "&curren;" : "currency",
        "&yen;" : "yen",
        // legal symbols
        "&copy;" : "Copyright",
        "&reg;" : "Registered",
        // mathematics symbols
        "&deg;" : "degrees",
        "&plusmn;" : "plus or minus",
        "&frac12;" : "one half",
        "&frac14;" : "one fourth",
        "&frac34" : "three fourths",
        "&times;" : "×",
        "&divide;" : "÷",
        // eth and thorn from Middle English
        "&ETH;" : "Th",
        "&eth;" : "th",
        "&THORN;" : "Th",
        "&thorn;" : "th",
        // typographic ligatures
        "&AElig;" : "Æ",
        "&aelig;" : "æ",
        "&OElig;" : "Œ",
        "&oelig;" : "œ",
        // some foreign symbols and accents
        "&Aring;" : "Å",
        "&Oslash;" : "Ø",
        "&Ccedil;" : "Ç",
        "&ccedil;" : "ç",
        "&szlig;" : "ß",
        "&Ntilde;" : "Ñ",
        "&ntilde;" : "ñ",
        "&nbsp;" : ""
    ]
    
    /// List of escape characters to remove
    private let escapeCharacters = ["\\t", "\\r", "\\n", "\\t"]
    
}
