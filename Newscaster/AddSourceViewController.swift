//
//  AddSourceViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/31/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class AddSourceViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var linkField: UITextField!
    
    @IBAction func addFeed(sender: UIButton) {
        if let name = nameField.text {
            var type = "google" // default value is a text search
            var link: String? // nil if a search query is used
            var query: String?
            // check if the link is a valid url
            if validateUrl(linkField.text!) {
                type = "none" // atom or rss will be determined later
                link = linkField.text!
            } else {
                // otherwise, the text entry becomes the search query
                query = linkField.text!
            }
            let feed = Feed(name: name, type: type, query: query, url: link, context: sharedContext)
            saveContext()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIButton) {
        // return to the feeds view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Determine if the url is correctly formatted.
    private func validateUrl(url: String) -> Bool {
        // regular url format
        let pattern = "^(https?:\\/\\/)([a-zA-Z0-9_\\-~]+\\.)+[a-zA-Z0-9_\\-~\\/\\.]+$"
        // check if string conforms to format
        if let _ = url.rangeOfString(pattern, options: .RegularExpressionSearch) {
            return true
        }
        return false
    }
    
}
