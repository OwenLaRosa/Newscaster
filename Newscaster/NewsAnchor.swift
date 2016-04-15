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
        // use the iOS "Daniel" voice
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
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
