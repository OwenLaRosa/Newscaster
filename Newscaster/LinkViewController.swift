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
    @IBOutlet var playButton: UIBarButtonItem!
    @IBOutlet var pauseButton: UIBarButtonItem!
    
    var newsAnchor: NewsAnchor!
    /// true if this instance of the view has already appeared, otherwise false
    var firstAppeared = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canDisplayBannerAds = true
        
        webView.delegate = self
        newsAnchor = NewsAnchor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // play button should be disabled to begin with
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItem = playButton
        playButton.enabled = false
        
        navigationItem.title = article.title
        var link = article.link
        if !firstAppeared {
            // article has already been loaded, no need to load it again
            return
        }
        if article.feed.type == "News" {
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
                // data has been downloaded, prevent redownloads when view appears
                self.firstAppeared = false
                let result = String(data: data, encoding: NSUTF8StringEncoding)
                // parse the result and assign it to the news anchor
                self.newsAnchor.stringToSpeak = HTMLScraper(html: result!).getContentsForTag("p").joinWithSeparator(" ")
            }
        }
    }
    
    @IBAction func didPressPlay(sender: UIBarButtonItem) {
        // turn it into a pause button
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItem = pauseButton
        if newsAnchor.speaking {
            // resume speaking the article
            newsAnchor.resumeSpeaking()
        } else {
            // start speaking the article
            newsAnchor.startSpeaking()
        }
    }
    
    @IBAction func didPressPause(sender: UIBarButtonItem) {
        // turn it into a play button
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItem = playButton
        newsAnchor.pauseSpeaking()
    }
    
}
