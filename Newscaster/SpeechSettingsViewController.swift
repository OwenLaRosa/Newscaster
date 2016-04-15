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
