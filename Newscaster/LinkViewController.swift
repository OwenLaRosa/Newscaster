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
    @IBOutlet var settingsButton: UIBarButtonItem!
    
    var newsAnchor: NewsAnchor!
    /// true if this instance of the view has already appeared, otherwise false
    var firstAppeared = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canDisplayBannerAds = true
        
        webView.delegate = self
        
        // play button should be disabled to begin with
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItems = [playButton, settingsButton]
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let newsAnchor = newsAnchor {
            // keep speaking if the settings view is shown
            if let currentVC = UIApplication.sharedApplication().delegate?.window!?.rootViewController!.presentedViewController {
                if currentVC is SpeechSettingsViewController {
                    return
                }
            }
            // otherwise, speaking should be stopped
            newsAnchor.stopSpeakingAtBoundary(.Immediate)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let destinationVC = segue.destinationViewController as! SpeechSettingsViewController
        destinationVC.newsAnchor = newsAnchor
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .LinkClicked {
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // get the html body when loading is finished
        // thanks to http://stackoverflow.com/questions/5167254/getting-the-html-source-code-of-a-loaded-uiwebview for the JavaScript expression
        let html = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        // print(html)
        // TODO: Extract article text from HTML
        
        // once that's done, enable the play button
        //playButton.enabled = true
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
                let stringToSpeak = HTMLScraper(html: result!).getContentsForTag("p").joinWithSeparator(" ")
                self.newsAnchor = NewsAnchor(stringToSpeak: stringToSpeak)
                dispatch_async(dispatch_get_main_queue()) {
                    self.playButton.enabled = true
                }
            }
        }
    }
    
    @IBAction func didPressPlay(sender: UIBarButtonItem) {
        // turn it into a pause button
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItems = [pauseButton, settingsButton]
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
        navigationItem.rightBarButtonItems = [playButton, settingsButton]
        newsAnchor.pauseSpeaking()
    }
    
}
