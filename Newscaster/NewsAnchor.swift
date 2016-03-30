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
    
    /// Start speaking the string from the beginning.
    public func startSpeaking() {
        let utterance = AVSpeechUtterance(string: stringToSpeak)
        // use the iOS "Daniel" voice
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
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
