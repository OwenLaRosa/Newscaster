//
//  LinkViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/31/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class LinkViewController: UIViewController {
    
    var article: Article!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = article.title
        NewsClient().downloadData(article.link) {data, response, error in
            if let htmlData = data {
                if let htmlString = String(data: htmlData, encoding: NSUTF8StringEncoding) {
                    self.webView.loadHTMLString(htmlString, baseURL: NSURL(string: self.article.link))
                }
            }
        }
    }
    
}
