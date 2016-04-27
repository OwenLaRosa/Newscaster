//
//  SpeechSettingsViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 4/15/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechSettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var newsAnchor: NewsAnchor?
    var speechVoices: [AVSpeechSynthesisVoice]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sort the list and move English voices to the top
        let speechVoices = AVSpeechSynthesisVoice.speechVoices().sort({$0.name < $1.name})
        self.speechVoices = speechVoices.filter() {$0.language.hasPrefix("en")} + speechVoices.filter() {!$0.language.hasPrefix("en")}
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
        tableView.reloadData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rateDidChange:", name: Notifications.rateDidChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pitchDidChange:", name: Notifications.pitchDidChange, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func applyButtonTapped(sender: UIButton) {
        newsAnchor?.resetSpeechSettings()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rateDidChange(notification: NSNotification) {
        print(notification.object)
        if let slider = notification.object as? UISlider {
            Settings.sharedInstance().rate = slider.value
            print("rate is: \(slider.value)")
        }
    }
    
    func pitchDidChange(notification: NSNotification) {
        print(notification.object)
        if let slider = notification.object as? UISlider {
            Settings.sharedInstance().pitch = slider.value
            print("pitch is: \(slider.value)")
        }
    }
    
}

extension SpeechSettingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // section 1: change rate
        // section 2: change pitch
        // section 3: change voice
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1 // one slider
        case 2:
            return speechVoices.count
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0, 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SliderTableViewCell", forIndexPath: indexPath) as! SliderTableViewCell
            cell.selectionStyle = .None
            cell.slider.continuous = false
            if indexPath.row == 0 {
                cell.slider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
                cell.slider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
                cell.didChangeNotification = Notifications.rateDidChange
            } else if indexPath.row == 1 {
                cell.slider.maximumValue = 2.0
                cell.slider.minimumValue = 0.5
                cell.didChangeNotification = Notifications.pitchDidChange
            }
            return cell
        case 2:
            let voice = speechVoices[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("SpeechVoiceTableViewCell", forIndexPath: indexPath) as! SpeechVoiceTableViewCell
            // determine the currently selected voice and show the checkmark
            if voice.language == Settings.sharedInstance().voice {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            cell.textLabel?.text = "\(voice.name) (\(voice.language))"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("SpeechVoiceTableViewCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Reset Settings"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "rate"
        case 1:
            return "pitch"
        case 2:
            return "voice"
        case 3:
            return "reset"
        default:
            return ""
        }
    }
    
}

extension SpeechSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let voice = speechVoices[indexPath.row]
        Settings.sharedInstance().voice = voice.language
        newsAnchor?.utterance.voice = voice
        
        // reflect changes in the UI
        tableView.reloadData()
    }
    
}
