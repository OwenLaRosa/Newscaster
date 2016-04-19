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
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    @IBAction func applyButtonTapped(sender: UIButton) {
        newsAnchor?.resetSpeechSettings()
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
        switch section {
        case 0, 1:
            return 1 // one slider
        case 2:
            return speechVoices.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0, 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SliderTableViewCell", forIndexPath: indexPath) as! SliderTableViewCell
            cell.selectionStyle = .None
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
