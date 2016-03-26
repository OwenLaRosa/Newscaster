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
    
    /// Individual words, defined by spaces, in the speech string
    private var words: [String] {
        return stringToSpeak.componentsSeparatedByString(" ")
    }
    
    /// Index of the word to be spoken
    var speechIndex = 0
    
    override init() {
        super.init()
        
        delegate = self
    }
    
    /// Start speaking the string from the beginning.
    public func startSpeaking() {
        
    }
    
    /// Pause currently active speech
    public func pauseSpeaking() {
        
    }
    
    /// Resume speech from the point in which is was paused
    public func resumeSpeaking() {
        
    }
    
    /// Speak the word at the next index
    private func speakAtIndex(index: Int) {
        if index > words.count - 1 {
            // index out of range, nothing to speak
            // reset the index
            speechIndex = 0
            return
        }
        let word = words[index]
        let utterance = AVSpeechUtterance(string: word)
        // use the iOS "Daniel" voice
        utterance.voice = AVSpeechSynthesisVoice(language: "en-uk")
        speakUtterance(utterance)
    }
    
}

extension NewsAnchor: AVSpeechSynthesizerDelegate {
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        // go to the next word
        speechIndex++
        speakAtIndex(speechIndex)
    }
    
}
