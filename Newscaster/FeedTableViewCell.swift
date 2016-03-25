//
//  FeedTableViewCell.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/31/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var feedDescriptionLabel: UILabel!
    
    var feed: Feed! {
        didSet {
            feedNameLabel.text = feed.name
            feedDescriptionLabel.text = "\(feed.type): \(feed.url ?? feed.query!)"
        }
    }
    
}
