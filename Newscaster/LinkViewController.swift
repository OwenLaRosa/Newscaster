//
//  LinkViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/31/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class LinkViewController: UIViewController, UIWebViewDelegate {
    
    var article: Article!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = article.title
        var link = article.link
        if article.feed.type == "bing" {
            // if the feed is a news result, then prepare the link
            link = HTMLScraper(html: "").getURLFromNewsLink(article.link)
        }
        if let url = NSURL(string: link) {
            // create a request from the url and load it
            let request = NSURLRequest(URL: url)
            self.webView.loadRequest(request)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // get the html body when loading is finished
        // thanks to http://stackoverflow.com/questions/5167254/getting-the-html-source-code-of-a-loaded-uiwebview for the JavaScript expression
        let html = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        print(html)
        // TODO: Extract article text from HTML
    }
    
}
