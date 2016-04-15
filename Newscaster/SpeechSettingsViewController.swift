//
//  SpeechSettingsViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 4/15/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class SpeechSettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func dismissButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension SpeechSettingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // section 1: change rate
        // section 2: change pitch
        // section 3: change voice
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
