//
//  SliderTableViewCell.swift
//  Newscaster
//
//  Created by Owen LaRosa on 4/15/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {
    
    var didChangeNotification = ""
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: didChangeNotification, object: sender))
    }
    
}
