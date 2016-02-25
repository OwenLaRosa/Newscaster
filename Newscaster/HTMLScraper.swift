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
    
}
