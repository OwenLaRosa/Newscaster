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
    
    var utterance: AVSpeechUtterance!
    
    init(stringToSpeak: String) {
        utterance = AVSpeechUtterance(string: stringToSpeak)
        // assign voice and properties from settings
        let settings = Settings.sharedInstance()
        utterance.voice = AVSpeechSynthesisVoice(language: settings.voice)
        utterance.rate = settings.rate
        utterance.pitchMultiplier = settings.pitch
    }
    
    /// Start speaking the string from the beginning.
    public func startSpeaking() {
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
    
}
