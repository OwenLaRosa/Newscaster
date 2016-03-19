//
//  LinkViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/31/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit
import iAd

class LinkViewController: UIViewController, UIWebViewDelegate {
    
    var article: Article!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canDisplayBannerAds = true
        
        webView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // play button should be disabled to begin with
        playButton.enabled = false
        
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
        loadPlainHTMLForUrl(link)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // get the html body when loading is finished
        // thanks to http://stackoverflow.com/questions/5167254/getting-the-html-source-code-of-a-loaded-uiwebview for the JavaScript expression
        let html = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        // print(html)
        // TODO: Extract article text from HTML
        
        // once that's done, enable the play button
        playButton.enabled = true
    }
    
    /// Load HTML from the destination URL, parse the result, and assign it to the article entity
    private func loadPlainHTMLForUrl(url: String) {
        NewsClient().downloadData(url) {data, response, error in
            if error != nil {
                return
            }
            if let data = data {
                let result = String(data: data, encoding: NSUTF8StringEncoding)
                // TODO: parse html and assign to article
                for i in HTMLScraper(html: result!).getContentsForTag("p") {
                    print("NEW ELEMENT")
                    print(i)
                }
            }
        }
    }
    
}
