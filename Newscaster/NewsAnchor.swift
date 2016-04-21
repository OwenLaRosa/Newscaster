//
//  NewsAnchor.swift
//  Newscaster
//
//  Created by Owen LaRosa on 3/26/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import AVFoundation

public class NewsAnchor: AVSpeechSynthesizer {
    
    /// String that will be spoken
    var stringToSpeak: String!
    /// String currently being spoken
    private var currentString: String!
    
    var utterance: AVSpeechUtterance!
    
    private var nextIndex = 0
    
    init(stringToSpeak: String) {
        utterance = AVSpeechUtterance(string: stringToSpeak)
        currentString = stringToSpeak
        // assign voice and properties from settings
        let settings = Settings.sharedInstance()
        utterance.voice = AVSpeechSynthesisVoice(language: settings.voice)
        utterance.rate = settings.rate
        utterance.pitchMultiplier = settings.pitch
    }
    
    /// Start speaking the string from the beginning.
    public func startSpeaking() {
        delegate = self
        speakUtterance(utterance)
    }
    
    /// Pause currently active speech
    public func pauseSpeaking() {
        pauseSpeakingAtBoundary(.Word)
    }
    
    /// Resume speech from the point in which is was paused
    public func resumeSpeaking() {
        continueSpeaking()
    }
    
    /// Changes speech utterance's settings and continues speaking
    public func resetSpeechSettings() {
        // use old speech settings until the next word
        pauseSpeaking()
        // get the new speech string
        let startIndex = currentString.startIndex.advancedBy(nextIndex)
        currentString = currentString.substringFromIndex(startIndex)
        // create a new utterance and assign the properties
        utterance = AVSpeechUtterance(string: currentString)
        let settings = Settings.sharedInstance()
        utterance.voice = AVSpeechSynthesisVoice(language: settings.voice)
        utterance.rate = settings.rate
        utterance.pitchMultiplier = settings.pitch
        // reset the index to 0
        // start speaking if speech was previously in-progress
        if speaking {
            // stop original speech and begin speaking the new utterance
            stopSpeakingAtBoundary(.Word)
            startSpeaking()
        }
    }
    
}

extension NewsAnchor: AVSpeechSynthesizerDelegate {
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        // move index to the next word to be spoken
        nextIndex = characterRange.location + characterRange.length
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        // reset the index when speaking is complete
        self.utterance = AVSpeechUtterance(string: stringToSpeak)
        let settings = Settings.sharedInstance()
        utterance.voice = AVSpeechSynthesisVoice(language: settings.voice)
        utterance.rate = settings.rate
        utterance.pitchMultiplier = settings.pitch
        nextIndex = 0
    }
    
}
