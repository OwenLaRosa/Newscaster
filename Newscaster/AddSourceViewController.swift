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
    
    var index: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // view's background is white, make sure the text is readable
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
        
        nameField.delegate = self
        linkField.delegate = self
        nameField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // reset status bar style when view dismisses
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    @IBAction func addFeed(sender: UIButton) {
        if let name = nameField.text {
            if !textContainsWords(name) {
                displayAlert("Invalid Input", message: "Names must contain valid letters and/or numbers.")
                return
            }
            var type = "News" // default value is a text search
            var link: String? // nil if a search query is used
            var query: String?
            // check if the link is a valid url
            if validateUrl(linkField.text!) {
                type = "RSS" // atom or rss will be determined later
                link = linkField.text!
            } else {
                // otherwise, the text entry becomes the search query
                query = linkField.text == "" ? nameField.text : linkField.text
            }
            let feed = Feed(name: name, type: type, query: query, url: link, index: index, context: sharedContext)
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
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(okButton)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// Determine if the text contains valid characters.
    private func textContainsWords(text: String) -> Bool {
        let pattern = "^[a-zA-Z0-9]"
        
        if let _ = text.rangeOfString(pattern, options: .RegularExpressionSearch) {
            return true
        }
        return false
    }
    
}

extension AddSourceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameField {
            // move cursor to the next text field
            linkField.becomeFirstResponder()
        }
        if textField == linkField {
            // call add feed button's method, initializing UIButton for sender parameter
            addFeed(UIButton())
        }
        return false
    }
    
}
